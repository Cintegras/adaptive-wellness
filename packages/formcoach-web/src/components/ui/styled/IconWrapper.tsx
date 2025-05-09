import React from 'react';
import { cn } from '@/lib/utils';
import { LucideIcon } from 'lucide-react';

interface IconWrapperProps {
  icon: LucideIcon;
  size?: number;
  className?: string;
  onClick?: () => void;
}

export const IconWrapper: React.FC<IconWrapperProps> = ({ 
  icon: Icon,
  size = 24,
  className = '',
  ...props 
}) => {
  return (
    <Icon 
      size={size} 
      className={cn('fc-icon', className)} 
      {...props} 
    />
  );
};

export default IconWrapper;