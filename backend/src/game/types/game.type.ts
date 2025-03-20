export type Color = 'black' | 'white';

export function oppositeColor(color: Color): Color {
  return color === 'black' ? 'white' : 'black';
}

export type Disk = Color | '';

export type Move = {
  color: Color;
  x: number;
  y: number;
};
