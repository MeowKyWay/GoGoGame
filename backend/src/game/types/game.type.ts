export type Color = 'black' | 'white';

export type Stone = Color | '';

export type Move = {
  color: Color;
  x: number;
  y: number;
};
