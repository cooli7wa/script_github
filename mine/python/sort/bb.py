import json

# Definition for singly-linked list.
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None

def stringToListNode(input):
    # Generate list from the input
    numbers = list(input)

    # Now convert that list into linked list
    dummyRoot = ListNode(0)
    ptr = dummyRoot
    for number in numbers:
        ptr.next = ListNode(number)
        ptr = ptr.next

    ptr = dummyRoot.next
    return ptr

def listNodeToString(node):
    if not node:
        return "[]"

    result = ""
    while node:
        result += str(node.val) + ", "
        node = node.next
    return "[" + result[:-2] + "]"

class Solution:
    def removeNthFromEnd(self, head, n):
        """
        :type head: ListNode
        :type n: int
        :rtype: ListNode
        """
        dummy = ListNode(0)
        dummy.next = head
        pre = None
        ptr = dummy
        i = 0
        while ptr:
            if pre is not None:
                pre = pre.next
            if i == n:
                pre = dummy
            ptr = ptr.next
            i += 1
        pre.next = pre.next.next
        return dummy.next


s = Solution()
ptr = stringToListNode("12345")
ptr = s.removeNthFromEnd(ptr, 6)
print(listNodeToString(ptr))