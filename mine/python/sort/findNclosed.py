import sys

class Solution:
    def threeClosed(self, nums, target):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        def findNclosed(nums, target, N, cur_num, result):
            if len(nums) < N or N < 2:
                return
            if N == 2:
                l, r = 0, len(nums)-1
                while l < r:
                    s = nums[l] + nums[r]
                    if s == target:
                        result[0] = cur_num + s
                        result[1] = 0
                        return
                    d = abs(target - s)
                    if d < result[1]:
                        result[0] = cur_num + s
                        result[1] = d
                    if s > target:
                        r -= 1
                    else:
                        l += 1
            else:
                for i in range(len(nums)-N+1):
                    if i == 0 or nums[i-1] != nums[i]:
                        findNclosed(nums[i+1:], target-nums[i], N-1, cur_num+nums[i], result)
                        if result[1] == 0:
                            return

        result = [0, sys.maxsize]
        findNclosed(sorted(nums), target, 3, 0, result)
        return [result[0], result[1]]


s = Solution()
print(s.threeClosed([-1,0,1,1,55], 3))
