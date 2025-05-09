import React, {useState} from 'react';
import {useNavigate} from 'react-router-dom';
import PageContainer from '@/components/PageContainer';
import PrimaryButton from '@/components/PrimaryButton';
import {Input} from '@/components/ui/input';
import {Form, FormControl, FormField, FormItem, FormLabel, FormMessage} from '@/components/ui/form';
import {useForm} from 'react-hook-form';
import {z} from 'zod';
import {zodResolver} from '@hookform/resolvers/zod';
import {Lock, Mail} from 'lucide-react';
import {useAuth} from '@/features/auth/hooks/useAuth';
import {useToast} from '@/components/ui/use-toast';
import {EmailVerification} from '@/features/auth/components/EmailVerification';

const signupSchema = z.object({
  email: z.string().email({ message: 'Please enter a valid email address' }),
  password: z.string().min(6, { message: 'Password must be at least 6 characters' }),
  confirmPassword: z.string(),
}).refine(data => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"],
});

type SignupValues = z.infer<typeof signupSchema>;

const Signup = () => {
  const navigate = useNavigate();
  const {signUp, loading: authLoading} = useAuth();
  const [isLoading, setIsLoading] = useState(false);
  const [verificationEmail, setVerificationEmail] = useState<string | null>(null);
  const {toast} = useToast();

  const form = useForm<SignupValues>({
    resolver: zodResolver(signupSchema),
    defaultValues: {
      email: '',
      password: '',
      confirmPassword: '',
    },
  });

  const onSubmit = async (values: SignupValues) => {
    setIsLoading(true);

    try {
      const {error} = await signUp(values.email, values.password);

      if (error) {
        toast({
          title: "Registration error",
          description: error.message,
          variant: "destructive",
        });
        return;
      }

      // Set the verification email to show the verification screen
      setVerificationEmail(values.email);

      toast({
        title: "Verification required",
        description: "Please check your email for a verification link.",
      });
    } catch (error) {
      toast({
        title: "Registration error",
        description: error instanceof Error ? error.message : "Failed to create account",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  };

  // If we're in verification state, show the verification component
  if (verificationEmail) {
    return (
      <PageContainer>
        <div className="flex flex-col items-center justify-center min-h-[80vh] font-inter">
          <div className="mb-10">
            <h1 className="font-bold text-[32px] text-center text-[#A4B1B7]">
              Verify Your Account
            </h1>
            <p className="font-normal text-[16px] text-[#A4B1B7] text-center mt-2">
              One last step to complete your registration
            </p>
          </div>

          <EmailVerification email={verificationEmail} />
        </div>
      </PageContainer>
    );
  }

  return (
    <PageContainer>
      <div className="flex flex-col items-center justify-center min-h-[80vh] font-inter">
        <div className="mb-10">
          <h1 className="font-bold text-[32px] text-center text-[#A4B1B7]">
            Create Account
          </h1>
          <p className="font-normal text-[16px] text-[#A4B1B7] text-center mt-2">
            Join FormCoach to start your fitness journey
          </p>
        </div>

        <div className="w-full rounded-lg p-6" style={{ backgroundColor: "rgba(176, 232, 227, 0.12)" }}>
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
              <FormField
                control={form.control}
                name="email"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-[#A4B1B7] text-[17px] font-normal font-inter">Email</FormLabel>
                    <FormControl>
                      <div className="relative">
                        <Input
                          {...field}
                          placeholder="yourname@example.com"
                          type="email"
                          autoComplete="username"
                          className="rounded-md w-full h-auto pl-[42px] pr-[13.5px] py-[13px] border-0 text-[17px] font-normal font-inter"
                          style={{
                            backgroundColor: "rgba(176, 232, 227, 0.12)",
                            color: "rgba(209, 235, 233, 0.62)"
                          }}
                        />
                        <Mail className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A4B1B7]" size={20} />
                      </div>
                    </FormControl>
                    <FormMessage className="text-[#FF4D4F]" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="password"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-[#A4B1B7] text-[17px] font-normal font-inter">Password</FormLabel>
                    <FormControl>
                      <div className="relative">
                        <Input
                          {...field}
                          placeholder="******"
                          type="password"
                          autoComplete="new-password"
                          className="rounded-md w-full h-auto pl-[42px] pr-[13.5px] py-[13px] border-0 text-[17px] font-normal font-inter"
                          style={{
                            backgroundColor: "rgba(176, 232, 227, 0.12)",
                            color: "rgba(209, 235, 233, 0.62)"
                          }}
                        />
                        <Lock className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A4B1B7]" size={20} />
                      </div>
                    </FormControl>
                    <FormMessage className="text-[#FF4D4F]" />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="confirmPassword"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel className="text-[#A4B1B7] text-[17px] font-normal font-inter">Confirm Password</FormLabel>
                    <FormControl>
                      <div className="relative">
                        <Input
                          {...field}
                          placeholder="******"
                          type="password"
                          autoComplete="new-password"
                          className="rounded-md w-full h-auto pl-[42px] pr-[13.5px] py-[13px] border-0 text-[17px] font-normal font-inter"
                          style={{
                            backgroundColor: "rgba(176, 232, 227, 0.12)",
                            color: "rgba(209, 235, 233, 0.62)"
                          }}
                        />
                        <Lock className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A4B1B7]" size={20} />
                      </div>
                    </FormControl>
                    <FormMessage className="text-[#FF4D4F]" />
                  </FormItem>
                )}
              />

              <PrimaryButton type="submit" disabled={isLoading} className="hover:scale-[1.02] transition-transform duration-200">
                {isLoading ? 'Creating Account...' : 'Create Account'}
              </PrimaryButton>
            </form>
          </Form>

          <div className="mt-6 text-center">
            <p className="font-normal text-[14px] text-[#A4B1B7]">
              Already have an account?{' '}
              <button 
                onClick={() => navigate('/login')}
                className="text-[#A4B1B7] hover:underline transition-all duration-200"
              >
                Sign In
              </button>
            </p>
          </div>
        </div>
      </div>
    </PageContainer>
  );
};

export default Signup;
