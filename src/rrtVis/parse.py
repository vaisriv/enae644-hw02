"""rrtVis.parse — load input data and RRT output CSVs"""

import csv
import json
import os
from dataclasses import dataclass

###############################################################################
# Data classes (mirror for Haskell types)
###############################################################################


@dataclass
class Obstacle:
    x: float
    y: float
    radius: float


@dataclass
class Workspace:
    x_min: float
    x_max: float
    y_min: float
    y_max: float


@dataclass
class Goal:
    x: float
    y: float
    radius: float


@dataclass
class Problem:
    workspace: Workspace
    start: tuple[float, float]
    goal: Goal
    epsilon: float


@dataclass
class TreeNode:
    node_id: int
    x: float
    y: float
    parent_id: int  # -1 for root


###############################################################################
# Loaders
###############################################################################


def load_obstacles(data_dir: str) -> list[Obstacle]:
    """parse `obstacles.txt` and return a list of Obstacle instances"""
    # TODO:
    # (step 4) implement
    raise NotImplementedError


def load_problem(data_dir: str, problem_num: str) -> Problem:
    """parse `pXX.json` and return a Problem instance"""
    # TODO:
    # (step 4) implement
    raise NotImplementedError


def load_search_tree(output_dir: str) -> list[TreeNode]:
    """read `search_tree.csv` (node_id, x, y, parent_id) and return nodes in order"""
    # TODO:
    # (step 5) implement
    raise NotImplementedError


def load_path(output_dir: str) -> list[tuple[float, float]] | str:
    """read `path.csv` and return either a list of (x, y) waypoints,
    or an error string if the file contains an ERROR: message"""
    # TODO:
    # (step 5) implement
    raise NotImplementedError
