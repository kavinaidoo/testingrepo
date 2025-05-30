var data = {
  type: "sankey",
  orientation: "h",
  node: {
    pad: 15,
    thickness: 30,
    line: {
    color: "black",
    width: 0.5
    },
  label: ["W-in", "A2", "B1", "B2", "C1", "C2"],
  color: ["blue", "red", "green", "blue", "blue", "blue"]
  },
  link: {
    source: [0,1,0,2,3,3],
    target: [2,3,3,4,4,5],
    value:  [8,4,2,8,4,2]
  }
}

var data = [data]

var layout = {
  title: {
      text: "Basic Sankey"
  },
  font: {
      size: 10
  }
}

Plotly.react('myDiv', data, layout,{displayModeBar: false})