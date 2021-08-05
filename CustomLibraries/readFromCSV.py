"""

This is python program to read from CSV file.

"""
import csv

def read_from_csv_file(filename):
    """
    :param filename:
    :return: data
    """

    data = []
    with open(filename,'rt' , encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            data.append(row)
    return data


