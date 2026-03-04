"""rrtVis — RRT path visualizer entrypoint"""

import click
from rrtVis import parse, visualize


@click.command()
@click.argument("output_dir", type=click.Path(exists=True, file_okay=False))
@click.argument("problem_num")
@click.option(
    "--data-dir",
    default="./data",
    show_default=True,
    help="Directory containing `obstacles.txt` and `pXX.json` files.",
)
@click.option(
    "--save/--no-save",
    default=True,
    show_default=True,
    help="Save the plot image to the output directory.",
)
def main(output_dir: str, problem_num: str, data_dir: str, save: bool) -> None:
    """Visualize RRT results for a given problem number

    OUTPUT_DIR  : directory containing `search_tree.csv` and `path.csv` (e.g. `./outputs/01`)

    PROBLEM_NUM : two-digit problem number (e.g. `01`, `05`)
    """
    # TODO:
    # (step 4) load obstacle + problem data
    obstacles = parse.load_obstacles(data_dir)
    problem = parse.load_problem(data_dir, problem_num)

    # TODO:
    # (step 5) load RRT outputs
    tree = parse.load_search_tree(output_dir)
    path = parse.load_path(output_dir)

    # TODO:
    # (step 7) render and save
    fig = visualize.render(obstacles, problem, tree, path)
    if save:
        out_file = f"{output_dir}/rrt_{problem_num}.png"
        fig.savefig(out_file, dpi=150, bbox_inches="tight")
        click.echo(f"Saved: {out_file}")
    else:
        import matplotlib.pyplot as plt

        plt.show()


if __name__ == "__main__":
    main()
