import collections


# [0, 1, 2, 5, 3, 4]
def breadth_first_search(graph, root):
    path = [0]
    print(path)


# [0, 1, 2, 3, 5, 4]
def depth_first_search(graph, root):
    path = []
    print(path)


if __name__ == '__main__':
    graph = {0: [1, 2, 5], 2: [0, 1, 3, 4], 1: [0, 2], 5: [0, 3], 3: [5, 2, 4], 4: [2, 3]}
    breadth_first_search(graph, 0)
    depth_first_search(graph, 0)

