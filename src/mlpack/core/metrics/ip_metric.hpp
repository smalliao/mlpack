/**
 * @file ip_metric.hpp
 * @author Ryan Curtin
 *
 * Inner product induced metric.  If given a kernel function, this gives the
 * complementary metric.
 */
#ifndef __MLPACK_METHODS_FASTMKS_IP_METRIC_HPP
#define __MLPACK_METHODS_FASTMKS_IP_METRIC_HPP

namespace mlpack {
namespace metric {

/**
 * The inner product metric, IPMetric, takes a given Mercer kernel (KernelType),
 * and when Evaluate() is called, returns the distance between the two points in
 * kernel space:
 *
 * @f[
 * d(x, y) = \sqrt{ K(x, x) + K(y, y) - 2K(x, y) }.
 * @f]
 *
 * @tparam KernelType Type of Kernel to use.  This must be a Mercer kernel
 *     (positive definite), otherwise the metric may not be valid.
 */
template<typename KernelType>
class IPMetric
{
 public:
  //! Create the IPMetric without an instantiated kernel.
  IPMetric();

  //! Create the IPMetric with an instantiated kernel.
  IPMetric(KernelType& kernel);

  //! Destroy the IPMetric object.
  ~IPMetric();

  /**
   * Evaluate the metric.
   *
   * @tparam VecTypeA Type of first vector.
   * @tparam VecTypeB Type of second vector.
   * @param a First vector.
   * @param b Second vector.
   * @return Distance between the two points in kernel space.
   */
  template<typename VecTypeA, typename VecTypeB>
  double Evaluate(const VecTypeA& a, const VecTypeB& b);

  //! Get the kernel.
  const KernelType& Kernel() const { return kernel; }
  //! Modify the kernel.
  KernelType& Kernel() { return kernel; }

  //! Returns a string representation of this object.
  std::string ToString() const;

 private:
  //! The locally stored kernel, if it is necessary.
  KernelType* localKernel;
  //! The reference to the kernel that is being used.
  KernelType& kernel;
};

}; // namespace metric
}; // namespace mlpack

// Include implementation.
#include "ip_metric_impl.hpp"

#endif
