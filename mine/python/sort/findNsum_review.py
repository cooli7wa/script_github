class Solution:
    def threeSum(self, nums, target):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        def findNsum(nums, target, N, path, results):
            if len(nums) < N or N < 2 or nums[0]*N > target or nums[-1]*N < target:
                return
            if N == 2:
                l, r = 0, len(nums)-1
                while l < r:
                    s = nums[l] + nums[r]
                    if s == target:
                        results.append(path+[nums[l],nums[r]])
                        while l < r and nums[l] == nums[l+1]:
                            l += 1
                        while l < r and nums[r] == nums[r-1]:
                            r -= 1
                        l += 1
                        r -= 1
                    else:
                        if s < target:
                            l += 1
                        else:
                            r -= 1
            else:
                for i in range(len(nums)-N+1):
                    if i == 0 or nums[i-1] != nums[i]:
                        findNsum(nums[i+1:], target-nums[i], N-1, path+[nums[i]], results)

        results = []
        findNsum(sorted(nums), target, 3, [], results)
        return results


s = Solution()
print(s.threeSum([1, 0, -1, 0, -2, 2], 0))
