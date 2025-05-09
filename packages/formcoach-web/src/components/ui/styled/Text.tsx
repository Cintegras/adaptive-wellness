import React from 'react';
import { cn } from '@/lib/utils';

interface TextProps extends React.HTMLAttributes<HTMLParagraphElement> {
  size?: 'normal' | 'small' | 'xs';
  as?: 'p' | 'span' | 'div';
  children: React.ReactNode;
}

export const Text: React.FC<TextProps> = ({ 
  size = 'normal', 
  as = 'p',
  className = '', 
  children,
  ...props 
}) => {
  const baseClass = size === 'normal' 
    ? 'fc-text' 
    : size === 'small' 
      ? 'fc-text-small'
      : 'text-[var(--fc-font-size-xs)] text-[var(--fc-color-text-primary)]';
  
  const Component = as;
  
  return (
    <Component 
      className={cn(baseClass, className)} 
      {...props}
    >
      {children}
    </Component>
  );
};

export default Text;