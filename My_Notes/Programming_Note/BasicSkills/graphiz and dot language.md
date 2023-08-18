# Graphviz and Dot Language

tags: #graphviz

## References

- [officail web site](https://graphviz.org/)

## What is Graphviz?

> Graphviz is open source graph visualization software. Graph visualization is a way of representing structural information as diagrams of abstract graphs and networks. It has important applications in networking, bioinformatics, software engineering, database and web design, machine learning, and in visual interfaces for other technical domains.

> The Graphviz layout programs take descriptions of graphs in a simple text language, and make diagrams in useful formats, such as images and SVG for web pages; PDF or Postscript for inclusion in other documents; or display in an interactive graph browser. Graphviz has many useful features for concrete diagrams, such as options for colors, fonts, tabular node layouts, line styles, hyperlinks, and custom shapes.

## Download Graphiz

from [official site](https://graphviz.org/#download)

## What is Dot Language?

The Dot language is a simple way to tell Graphviz how to draw your diagrams. It uses words and symbols to describe the connections between things. You write down what should be in the picture, and Dot takes care of the rest.

learn dot language [here](https://graphviz.org/doc/info/lang.html)

### Basic Example

Here's a simple Dot language example:

```
graph MyGraph {
  A -- B -- C;
  A -- C;
}
```

In this example, we have three things: A, B, and C. The lines (`--`) show how they're connected. Graphviz reads this and creates a picture where A, B, and C are connected by lines.

### How to Use Graphviz and Dot

1. **Write Dot Code**: First, write your Dot code in a text editor. Describe how things are connected using simple words and symbols.

2. **Save**: Save your Dot code in a file with a `.dot` extension, like `mygraph.dot`.

3. **Generate**: Run Graphviz on your Dot file. Graphviz turns your text into a visual diagram and creates an image file, like a `.png` or `.svg`. See commands [here](https://graphviz.org/doc/info/command.html).

4. **View**: Open the image file to see your diagram. You can use any image viewer to see the result.
