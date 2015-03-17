#import "AutomaticGeneration.h"
#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>


#include <Eigen/Dense>
#include <Eigen/Sparse>
#include <Eigen/SparseQR>
#include <Eigen/IterativeLinearSolvers>
#include <Eigen/SparseCholesky>

#include <iostream>
using Eigen::MatrixXd;
using Eigen::VectorXd;


@implementation AutomaticGeneration
+ (NSImage *) generatePossionHeightMap: (NSImage *) input {
    NSLog(@"%@", input);
    NSBitmapImageRep * rep = input.representations[0];

    NSLog(@"%p", [rep bitmapData]);
    NSLog(@"%d", [rep bytesPerRow]);
    NSLog(@"%d", [rep bytesPerPlane]);

    if (rep.bitsPerPixel != 4 * 8) {
        NSLog(@"Error: Only supports 8 bit RGBA images");
        return nil;
    }

    uint8_t * inputData = static_cast<uint8_t *>(rep.bitmapData);

    MatrixXd Img = MatrixXd::Zero((rep.pixelsWide + 2), (rep.pixelsHigh + 2));
    for (int i = 0; i < Img.rows(); ++i) {
        for (int j = 0; j < Img.cols(); ++j) {
            long idx = i*(Img.cols()-2) + j;
            if (i == 0 || i == Img.rows()-1 || j == 0 || j == Img.cols()-1) {
                Img(i, j) = 0.0;
            } else {
                long idx = (rep.bitsPerPixel / 8) * (rep.pixelsWide * (j-1) + (i-1));
                // For now, threshhold the red component to set boundary conditions
                if (inputData[idx+0] > 127) {
                    Img(i, j) = 1.0;
                } else {
                    Img(i, j) = 0.0;
                }
            }
        }
    }

    int size = Img.rows() * Img.cols();
    Eigen::SparseMatrix<double> A(size, size);
    VectorXd B = VectorXd::Zero(size);
    std::cout << "Debug size" << size << std::endl;

    float dirichlet_boundary = 0.0;
    float dx2 = (1.0 / size);
    float g = 1.0;
    // Fill up image matrix with data
    for (int i = 0; i < Img.rows(); ++i) {
        for (int j = 0; j < Img.cols(); ++j) {
            //long idx = i*Img.cols() + j;
            long idx = (i + 0)*(Img.cols()) + j + 0;
            // On the 1 px boarder around the image
            if (Img(i, j) == 0.0) {
                A.insert(idx, idx) = 1.0;
                B(idx) = dirichlet_boundary;
            } else {
                long idx_px = (i + 1)*(Img.cols()) + j + 0;
                long idx_nx = (i - 1)*(Img.cols()) + j + 0;
                long idx_py = (i + 0)*(Img.cols()) + j + 1;
                long idx_ny = (i + 0)*(Img.cols()) + j - 1;

                // Encoding matrix for poisson's equation
                // See http://en.wikipedia.org/wiki/Discrete_Poisson_equation
                A.insert(idx, idx) = 4.0;
                A.insert(idx, idx_py) = -1.0;
                A.insert(idx, idx_ny) = -1.0;
                A.insert(idx, idx_px) = -1.0;
                A.insert(idx, idx_nx) = -1.0;
                B(idx) = dx2*g;
            }
        }
    }

    std::cout << "Inverting matrix" << std::endl;
    //VectorXd X = A.colPivHouseholderQr().solve(B);
    A.makeCompressed();
    //Eigen::SparseQR<Eigen::SparseMatrix<double>, Eigen::COLAMDOrdering<int> > solver;
    //Eigen::ConjugateGradient<Eigen::SparseMatrix<double> > solver;
    //Eigen::SimplicialLDLT<Eigen::SparseMatrix<double> > solver;
    Eigen::BiCGSTAB<Eigen::SparseMatrix<double> > solver;
    std::cout << "Computing" << std::endl;;
    solver.compute(A);
    std::cout << "solved" << std::endl;;
    VectorXd X = solver.solve(B);
    // For now just rescale X
    X /= X.maxCoeff();
    //std::cout << X << std::endl;;
    std::cout << "wRiting imag" << std::endl;;
    // Reference: http://stackoverflow.com/questions/3416599/creating-an-nsimage-from-bitmap-data
    long width = (Img.rows() - 2);
    long height = (Img.cols() - 2);
    uint8_t * data = new uint8_t [height * width * 4];

    for (int i = 0; i < width; ++i) {
        for (int j = 0; j < height; ++j) {
            // Index in X
            long idx = (i + 1)*(Img.cols()) + j + 1;
            float height = X[idx];

            int didx = (j * width + i) * 4;
            data[didx+0] = (int) (height * 255);
            data[didx+1] = (int) (height * 255);
            data[didx+2] = (int) (height * 255);
            data[didx+3] = 255;

        }
    }
    std::cout << "DONE making data" << std::endl;

    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;

    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,   // data provider
                                    NULL,       // decode
                                    YES,        // should interpolate
                                    renderingIntent);

    NSImage * img = [[NSImage alloc] initWithCGImage:iref size:NSMakeSize(width, height)];

    return img;
}
@end
