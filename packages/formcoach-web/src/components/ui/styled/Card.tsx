import React from 'react';
import { cn } from '@/lib/utils';

interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  highlight?: boolean;
  hover?: boolean;
  children: React.ReactNode;
}

export const Card: React.FC<CardProps> = ({ 
  highlight = false,
  hover = false,
  className = '', 
  children,
  ...props 
}) => {
  const baseClass = highlight 
    ? 'fc-highlight-card' 
    : 'fc-card p-4';
  
  return (
    <div 
      className={cn(
        baseClass, 
        hover && 'fc-card-hover',
        className
      )} 
      {...props}
    >
      {children}
    </div>
  );
};

export default Card;