
# Amplifying the Impact of Your Code

<span id="introduction"/>

If you'd love to see more people using your code.... to magnify the impact of the code you already write... it makes sense to study successful open source libraries. They become successful and popular because, first and foremost, they let people do things they care about: build software and solve problems which are important to them. But just solving an important problem isn't enough. The library also has to be *usable*. It needs to be easy for developers to adopt, to learn, to integrate in their existing application. These days, we all have too much to learn already; in picking between two libraries, we're going to naturally tend towards the one that will make it easiest for us to hit the ground running... and that's only natural.

Let's study a wildly successful example: the excellent Pandas data analysis library. This library does an amazing and remarkable amount of magic under the hood, and we're not going to study any of that here. Rather, we're going to focus on the magic on the surface: the interface this library exposes. It's core abstraction is something called a **dataframe**:

<span id="dataframeExample"/>


```python
import pandas
df = pandas.DataFrame({
        'A': [-137, 22, -3, 4, 5],
        'B': [10, 11, 121, 13, 14],
        'C': [3, 6, 91, 12, 15],
    })
```

Here, we've created an object called `df`, which has three columns of data, labed `A`, `B`, and `C`. The dictionary passed in maps each column name to a list of column data. So in your mind, you rotate each horizontal list into a vertical column - got it? Then the data is organized like this:


```python
df
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-137</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>22</td>
      <td>11</td>
      <td>6</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-3</td>
      <td>121</td>
      <td>91</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>13</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>



The far left is an index, and the columns of data are headed by their names. Now, Pandas lets you do some interesting things like select a certain subset of the data, according to a criteria. For example:

<span id="selectSubset"/>


```python
positive_a = df[df.A > 0]
positive_a
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>22</td>
      <td>11</td>
      <td>6</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>13</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>



See what's happening: the expression `df.A > 0` tells Pandas: "Give me a new DataFrame, consisting only of those rows of `df` whose value in the `A` column is positive."  We can do more sophisticated expressions too:

<span id="createNewDataFrame"/>


```python
# Bigger B column values
big_b = df[df.B >= 14]
big_b
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2</th>
      <td>-3</td>
      <td>121</td>
      <td>91</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Or even express relationships between different columns:
coupled = df[df.A + df.B < 20]
coupled
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-137</td>
      <td>10</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>4</td>
      <td>13</td>
      <td>12</td>
    </tr>
    <tr>
      <th>4</th>
      <td>5</td>
      <td>14</td>
      <td>15</td>
    </tr>
  </tbody>
</table>
</div>



In an expression like `df[df.A > 0]`, the part in the brackets becomes a filter; you get a new `DataFrame` with only the matching rows.

But when you think about it, **that's a little weird**. Boolean expressions are supposed to evaluate to either True or False. That means everything I typed above should become either `df[True]` or `df[False]` at runtime... encoding no information about the rows you actually want.

**So what's going on? How in the world does this work?**

# Magic Methods

Let's explore all this by building our own data-processing library, called `fakepandas`. We won't implement any of the real work Pandas does under the hood, so you'll always want to use Pandas for any actual data-processing work. Instead, we'll focus on the surface magic... how Pandas provides its interface. Our goal is to reinvent that with `fakepandas`, and learn a lot in the process, so we can this Python magic in our own libraries.

And in fact, it turns out this magic relies on a a feature of Python called **magic methods**.

TODO: Write more narration, etc. below. About 97% of the code I'll use in the oriole is below, I just need to write more exposition, etc.


```python
def num_rows(d):
    '''
    Get number of data rows.

    Raise ValueError if not all columns have the same number of rows.
    '''
    if len(d) == 0:
        return 0
    def gen_columns():
        for v in d.values():
            yield v
    columns = gen_columns()
    length = len(next(columns))
    for index, column in enumerate(columns, 1):
        if len(column) != length:
            raise ValueError(index)
    return length
```


```python
# The operator module does not provide functions for the logical "and"
# and "or" operators, only the bitwise "&" and "|". So we make our own
# functions for the logicals.
def logical_and(a, b):
    return a and b

def logical_or(a, b):
    return a or b

class GeneralComparison:
    '''
    A generic representation of a comparison.

    Used when comparing two columns to each other (i.e., two LabelReferences).
    '''
    def __init__(self, lookup, value, operate):
        self.lookup = lookup
        self.value = value
        self.operate = operate
    def apply(self, data, row_number):
        other_value = self.lookup(data, row_number)
        return self.operate(other_value, self.value)
    # __and__ is actually bitwise and ("a & b"), not logical and ("a
    # and b").  Unfortunately, no current version of Python provides a
    # magic method for logical and.  Thus, we have little choice but
    # to fake it using bitwise and.
    def __and__(self, other):
        return Conjunction(self, other, logical_and)
    # The situation with __or__ is exactly analogous.
    def __or__(self, other):
        return Conjunction(self, other, logical_or)
```


```python
class Comparison(GeneralComparison):
    '''
    Simplified form of comparison.

    Used when comparing a column (LabelReference) to a constant value.
    '''
    def __init__(self, label: str, value, operate):
        def lookup(data, row_number):
            return data[label][row_number]
        super().__init__(lookup, value, operate)
```


```python
class Conjunction:
    '''
    Represents a logical "and" or "or" relationship between two expressions.

    combine will generally be set to either logical_and or logical_or.
    '''
    def __init__(self, left: GeneralComparison, right: GeneralComparison, combine: 'func'):
        self.left = left
        self.right = right
        self.combine = combine
    def apply(self, data: dict, row_number: int):
        return self.combine(self.left.apply(data, row_number), self.right.apply(data, row_number))


```


```python
import operator
class LabelReference:
    '''
    Represents a labeled column in a Dataset.
    '''
    def __init__(self, label: str):
        self.label = label
    def compare(self, value, operate):
        return Comparison(self.label, value, operate)
    def __lt__(self, value):
        return self.compare(value, operator.lt)
    def __gt__(self, value):
        return self.compare(value, operator.gt)
    def __ge__(self, value):
        return self.compare(value, operator.ge)
    def __le__(self, value):
        return self.compare(value, operator.le)
    def __eq__(self, value):
        return self.compare(value, operator.eq)
    def __add__(self, other):
        return PairedLabelReference(self, other, operator.add)
    def __sub__(self, other):
        return PairedLabelReference(self, other, operator.sub)
    def __mod__(self, other):
        return PairedLabelReference(self, other, operator.mod)


```


```python
class PairedLabelReference(LabelReference):
    '''
    Represents two separate columns in some comparision relation to each other.
    '''
    def __init__(self, first: LabelReference, second: LabelReference, operate: 'func'):
        self.first = first
        self.second = second
        self.operate = operate
    def lookup(self, data: dict, row_number: int):
        first_value = data[self.first.label][row_number]
        if isinstance(self.second, LabelReference):
            second_value = data[self.second.label][row_number]
        else:
            second_value = self.second
        return self.operate(first_value, second_value)
    def compare(self, value, operate: 'func'):
        return GeneralComparison(self.lookup, value, operate)


```


```python
class Dataset:
    '''
    Core class representing a set of data.

    Filter rows with obj[expression].
    '''
    def __init__(self, data: dict):
        self.data = data
        self.length = num_rows(data)
        self.labels = sorted(data.keys())

    def __getattr__(self, label: str):
        if label not in self.data:
            raise AttributeError("'{}' object has no attribute '{}'".format(self.__class__.__name__, label))
        return LabelReference(label)

    def __getitem__(self, comparison: GeneralComparison):
        filtered_data = dict((label, []) for label in self.labels)
        def append_row(row_number):
            for label in self.labels:
                filtered_data[label].append(self.data[label][row_number])
        for row_number in range(self.length):
            if comparison.apply(self.data, row_number):
                append_row(row_number)
        return Dataset(filtered_data)

    # presentation/rendering methods
    def __str__(self):
        return self.pprint_str()

    def pprint_str(self):
        # helpers
        def width_of(label):
            width = max(len(str(value)) for value in self.data[label])
            width = max([width, len(str(label))])
            return width
        def format(value, label):
            return '{value:>{width}}'.format(value=str(value), width=field_widths[label])

        # precompute
        field_widths = {label: width_of(label) for label in self.labels}
        table_width = sum(width for width in field_widths.values()) + 3 * (len(self.labels)-1) + 4
        HR = '-' * table_width

        # render lines
        labels_line = '| ' + ' | '.join(format(label, label) for label in self.labels) + ' |'
        lines = [
            HR,
            labels_line,
            HR,
        ]
        for row_number in range(self.length):
            formatted_values = (format(self.data[label][row_number], label) for label in self.labels)
            lines.append('| ' + ' | '.join(formatted_values) + ' |')
        lines.append(HR)
        return '\n'.join(lines)
```


```python
ds = Dataset({
    'A': [-1, 2, -3, 4, 5],
    'B': [10, 11, 12, 13, 14],
    'C': [3, 6, 9, 12, 15],
})

ds2 = Dataset({
    'A': [-137, 22, -3, 4, 5],
    'B': [10, 11, 121, 13, 14],
    'C': [3, 6, 91, 12, 15],
})
```


```python
# TODO: Make it produce a nicer html rendering, like Pandas does
# Short version is I need to add a Dataset.to_html() method and 
# convince jupyter to pass it through IPython.display.HTML automagically
print(ds)
print(ds[ds.A < 0])
print(ds[ds.A > 0])
print(ds[ds.B >= 12])
print(ds[ds.B <= 12])
print(ds[(ds.A > 0) & (ds.B >= 12)])
print(ds[(ds.A >= 3) | (ds.B == 11)])
print(ds[ds.A + ds.B < 10])
print(ds[ds.B - ds.C >= 3])
print(ds[ds.A + ds.B == 19])
print(ds[ds.B - ds.C >= 3])
print(ds[(ds.A > 0) & (ds.B >= 12)])
print(ds[(ds.A >= 3) | (ds.B == 11)])
print(ds[ds.C + 2 < ds.B])
print(ds[ds.C % 2 == 0])
print(ds[ds.C % 2 == 1])
```

    ----------------
    |  A |  B |  C |
    ----------------
    | -1 | 10 |  3 |
    |  2 | 11 |  6 |
    | -3 | 12 |  9 |
    |  4 | 13 | 12 |
    |  5 | 14 | 15 |
    ----------------
    ---------------
    |  A |  B | C |
    ---------------
    | -1 | 10 | 3 |
    | -3 | 12 | 9 |
    ---------------
    ---------------
    | A |  B |  C |
    ---------------
    | 2 | 11 |  6 |
    | 4 | 13 | 12 |
    | 5 | 14 | 15 |
    ---------------
    ----------------
    |  A |  B |  C |
    ----------------
    | -3 | 12 |  9 |
    |  4 | 13 | 12 |
    |  5 | 14 | 15 |
    ----------------
    ---------------
    |  A |  B | C |
    ---------------
    | -1 | 10 | 3 |
    |  2 | 11 | 6 |
    | -3 | 12 | 9 |
    ---------------
    ---------------
    | A |  B |  C |
    ---------------
    | 4 | 13 | 12 |
    | 5 | 14 | 15 |
    ---------------
    ---------------
    | A |  B |  C |
    ---------------
    | 2 | 11 |  6 |
    | 4 | 13 | 12 |
    | 5 | 14 | 15 |
    ---------------
    ---------------
    |  A |  B | C |
    ---------------
    | -1 | 10 | 3 |
    | -3 | 12 | 9 |
    ---------------
    ---------------
    |  A |  B | C |
    ---------------
    | -1 | 10 | 3 |
    |  2 | 11 | 6 |
    | -3 | 12 | 9 |
    ---------------
    ---------------
    | A |  B |  C |
    ---------------
    | 5 | 14 | 15 |
    ---------------
    ---------------
    |  A |  B | C |
    ---------------
    | -1 | 10 | 3 |
    |  2 | 11 | 6 |
    | -3 | 12 | 9 |
    ---------------
    ---------------
    | A |  B |  C |
    ---------------
    | 4 | 13 | 12 |
    | 5 | 14 | 15 |
    ---------------
    ---------------
    | A |  B |  C |
    ---------------
    | 2 | 11 |  6 |
    | 4 | 13 | 12 |
    | 5 | 14 | 15 |
    ---------------
    ----------------
    |  A |  B |  C |
    ----------------
    | -1 | 10 |  3 |
    |  2 | 11 |  6 |
    | -3 | 12 |  9 |
    |  4 | 13 | 12 |
    |  5 | 14 | 15 |
    ----------------
    ---------------
    | A |  B |  C |
    ---------------
    | 2 | 11 |  6 |
    | 4 | 13 | 12 |
    ---------------
    ----------------
    |  A |  B |  C |
    ----------------
    | -1 | 10 |  3 |
    | -3 | 12 |  9 |
    |  5 | 14 | 15 |
    ----------------



```python

```
