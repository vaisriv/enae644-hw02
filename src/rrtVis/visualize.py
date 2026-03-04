"""rrtVis.visualize — render RRT results using matplotlib"""

import matplotlib.figure
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import numpy as np

from rrtVis.parse import Goal, Obstacle, Problem, TreeNode


###############################################################################
# Rendering
###############################################################################


def render(
    obstacles: list[Obstacle],
    problem: Problem,
    tree: list[TreeNode],
    path: list[tuple[float, float]] | str,
) -> matplotlib.figure.Figure:
    """render the full RRT result into a matplotlib Figure and return it

    if `path` is a string it is treated as an error message and displayed
    as an annotation on the plot instead of drawing a path
    """
    fig, ax = plt.subplots()

    # TODO:
    # (step 7)
    # - draw workspace bounds
    # - draw obstacles
    # - draw search tree edges
    # - draw start and goal
    # - draw path or error message

    ax.set_aspect("equal")
    ax.set_title("RRT Search")
    return fig


###############################################################################
# Drawing helpers
###############################################################################


def draw_obstacles(ax, obstacles: list[Obstacle]) -> None:
    """draw filled obstacle circles"""
    # TODO:
    # (step 7) implement
    raise NotImplementedError


def draw_workspace(ax, problem: Problem) -> None:
    """draw workspace boundary rectangle"""
    # TODO:
    # (step 7) implement
    raise NotImplementedError


def draw_tree(ax, tree: list[TreeNode]) -> None:
    """draw all edges in the search tree as thin lines"""
    # TODO:
    # (step 7) implement
    raise NotImplementedError


def draw_path(ax, path: list[tuple[float, float]]) -> None:
    """draw the solution path as a bold highlighted line"""
    # TODO:
    # (step 7) implement
    raise NotImplementedError


def draw_error(ax, message: str) -> None:
    """display an error message centered on the plot"""
    # TODO:
    # (step 7) implement
    raise NotImplementedError


def draw_goal(ax, goal: Goal) -> None:
    """draw the goal region as a semi-transparent circle"""
    # TODO:
    # (step 7) implement
    raise NotImplementedError
