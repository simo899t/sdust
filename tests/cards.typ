#import "@local/sdust:0.1.0": *
#show: page-setup
= Cards
#theorem(title: "Theorem 2.1 (Pythagorean theorem)")[
  For a right-angled triangle with legs $a$ and $b$ and hypotenuse $c$,

  #boxed(inset: (x: 10pt, y: 10pt), stroke: 0.6pt, stroke-color: rgb(3,3,3))[$ a^2 + b^2 = c^2 $]
]

#definition(title: "Definition 2.2 (Injective function)")[
  A function $f: A -> B$ is *injective* if
  $ f(x) = f(y) arrow.r.double x = y. $
]

#example(title: "Example 2.3")[
  The derivative of $f(x) = x^3$ is
  $ f'(x) = 3x^2. $
]

#proof[
  Let $a$ and $b$ be odd integers. Then there exist integers $m$ and $n$ such that
  $a = 2m + 1$ and $b = 2n + 1$.

  Therefore,
  $ a + b = 2m + 2n + 2 = 2(m+n+1), $
  which is even. #QED
]

#question(title: "Exercise 5")[
  What is the probability of rolling a $6$ with a fair six-sided die?
]

#answer[
  There is one favourable outcome out of six possible outcomes, so
  $ P(X = 6) = 1/6. $
]