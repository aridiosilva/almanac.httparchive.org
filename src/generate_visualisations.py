import os
from io import BytesIO

import matplotlib
import matplotlib.pyplot as plt
import pandas as pd

from scour import scour

OUTLIER_MIN = 30

def generate_histogram(year, key, x, y, x_label):
    path = 'data/%s/%s.json' % (year, key)

    print('\nGenerating histogram from the following file: %s' % path)

    # Read the data file for the visualisation
    data = pd.read_json(path)
    original_length = len(data)

    # Rationalise the data set, like HA currently does.
    data = data[data.cdf < 0.95]
    print('Reduced the data set from %s to %s to fall within acceptable margins.' % (original_length, len(data)))
    
    data[y] *= 100

    # Plot the graph
    fig, ax = plt.subplots()   

    ax.bar(data[x], data[y], width=8, align='edge')
    ax.set_xlabel(x_label)
    ax.set_ylabel('Probability density')

    # Save the figure into a buffer
    buf = BytesIO()
    plt.savefig(buf, format='svg')

    # Read the buffer as an svg string
    svg = buf.getvalue().decode('UTF-8')

    # Optimise the svg image
    svg = scour.scourString(svg)

    return svg


# REMOVE - Just for testing
# generate_histogram(2019, '01_01', 'kbytes', 'pdf', 'KB')
