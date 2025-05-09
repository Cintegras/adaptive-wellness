import React from 'react';
import { cn } from '@/lib/utils';
import { AlertCircle } from 'lucide-react';

interface FormFieldProps extends React.HTMLAttributes<HTMLDivElement> {
  label: string;
  error?: string;
  children: React.ReactNode;
}

export const FormField: React.FC<FormFieldProps> = ({ 
  label,
  error,
  className = '',
  children,
  ...props 
}) => {
  return (
    <div className={cn('space-y-1', className)} {...props}>
      <label className="fc-input-label">{label}</label>
      {children}
      {error && (
        <div className="fc-form-error">
          <AlertCircle size={14} />
          <span>{error}</span>
        </div>
      )}
    </div>
  );
};

export default FormField;