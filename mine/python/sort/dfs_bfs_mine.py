import collections


def breadth_first_search(graph, root):
    visited, queue = {0}, collections.deque([root])
    path = [0]
    while queue:
        vertex = queue.popleft()
        for neighbour in graph[vertex]:
            if neighbour not in visited:
                visited.add(neighbour)
                queue.append(neighbour)
                path.append(neighbour)
    print(path)


def depth_first_search(graph, root):
    visited = set()
    path = []

    def dfs(graph, v):
        visited.add(v)
        path.append(v)
        for w in graph[v]:
            if w not in visited:
                dfs(graph, w)

    dfs(graph, root)
    print(path)


if __name__ == '__main__':
    graph = {0: [1, 2, 5], 2: [0, 1, 3, 4], 1: [0, 2], 5: [0, 3], 3: [5, 2, 4], 4: [2, 3]}
    breadth_first_search(graph, 0)
    depth_first_search(graph, 0)

