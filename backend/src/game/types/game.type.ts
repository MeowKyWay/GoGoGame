export type Color = 'black' | 'white';

export type Disk = Color | '';

export type Move = {
  color: Color;
  x: number;
  y: number;
};
