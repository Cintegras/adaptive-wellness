import React from 'react';
import { cn } from '@/lib/utils';

interface HeadingProps extends React.HTMLAttributes<HTMLHeadingElement> {
  level?: 1 | 2 | 3;
  children: React.ReactNode;
}

export const Heading: React.FC<HeadingProps> = ({ 
  level = 1, 
  className = '', 
  children,
  ...props 
}) => {
  const baseClass = level === 1 
    ? 'fc-heading' 
    : level === 2 
      ? 'fc-subheading'
      : 'text-[var(--fc-font-size-body)] font-[var(--fc-font-weight-semibold)] text-[var(--fc-color-text-primary)]';
  
  const Component = `h${level}` as keyof JSX.IntrinsicElements;
  
  return (
    <Component 
      className={cn(baseClass, className)} 
      {...props}
    >
      {children}
    </Component>
  );
};

export default Heading;