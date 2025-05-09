import React from 'react';
import { cn } from '@/lib/utils';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'text';
  isLoading?: boolean;
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({ 
  variant = 'primary', 
  isLoading = false,
  className = '',
  children,
  ...props 
}) => {
  const baseClass = variant === 'primary' 
    ? 'fc-button-primary' 
    : variant === 'secondary' 
      ? 'fc-button-secondary'
      : 'text-[var(--fc-color-text-accent)] hover:underline';
  
  return (
    <button 
      className={cn(baseClass, className, isLoading ? 'opacity-70 cursor-not-allowed' : '')} 
      disabled={isLoading || props.disabled}
      {...props}
    >
      {isLoading ? (
        <div className="flex items-center justify-center">
          <div className="animate-spin w-5 h-5 border-2 border-t-transparent border-[var(--fc-color-text-accent)] rounded-full mr-2"></div>
          <span>Loading...</span>
        </div>
      ) : children}
    </button>
  );
};

export default Button;