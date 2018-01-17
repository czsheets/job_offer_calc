import numpy as np
from scipy.special import comb

def jobs(probability = None, dream = None, total = None, decay = .01, offers = 1):
    print("This is a silly game to check your worst case scenario on jobs, using some questionable math. The \n \
          program will ask you whether you want to enter your expected probability of getting a job at each of \n \
          your 'key' jobs: those you are most excited about. If you choose not to do this, you can just enter how \n \
          many of your interviews are the focus, and then enter the average expected probability. From here you can \n \
          enter the total number of interviews, assuming you'll be bumping up your numbers a bit. There is a built-in \n \
          decay rate, which assumes that for every interview after your primary ones, fatigue and other factors will \n \
          begin to decrease the success rate. It's currently set to decrease by .01 per interview, but you can change it.")
    percent_yes = []
    percent_no = []
    each_percent = input("Are you entering the probability for each of your top interviews? Y/N:   ")
    if each_percent == "Y":
        probability = input("Enter each probability for your top interviews, in decimal form, separated by a space:   ")
        for num in str.split(probability, " "):
            percent_yes.append(float(num))
            percent_no.append(1 - float(num))
        dream_percentage = 1 - list(np.cumprod(percent_no))[-1]
        total = len(percent_yes)
    elif each_percent == "N":
        total = int(input("Enter the number of primary jobs you're applying for:   "))
        percent_yes = float(input("Enter the average probability for your top interviews in decimal form:   "))
        percent_no = 1-percent_yes
        dream_percentage = 1-(percent_no**total)
    else:
        return(print("Sorry, you need to answer this question with a capital 'Y' or 'N'. Feel free to try again."))
    if type(probability) is list and max(probability) > 1:
        return(print("It looks like you didn't enter your percentages correctly. Every number has to be less than one."))
    average_probability = np.mean([percent_yes])   
    applications = int(input("Enter the total number of jobs you are applying for:   "))
    if applications > total:
        extra_interviews = applications - total
        decay_yes = input("Do you want to set the decay rate (the percentage drop with each additional\
                                                              interview beyond your top interviews) from .01? Y/N   ")
        if decay_yes == "Y":
            decay = float(input("How much decrease in probability do expect with each additional interview?   "))
        decay_list = sum([list(np.repeat(average_probability, total)), list(np.repeat(-decay, extra_interviews))],[])
        decay_list = sum([list(decay_list[:total-1]), list(np.cumsum(decay_list[total-1:]))],[])
        decay_list = [x*(x>=0) for x in decay_list]
        decay_list_neg = np.subtract(1, decay_list)
        decay_list_final = 1 - np.cumprod(decay_list_neg)[-1]
        print("\nWith " + str(total) + " primary interviews your chances of getting a job are: " + \
              str(round(dream_percentage,2)) + "\nWith " + str(extra_interviews) + " additional interviews," + \
              " this increases to: " + str(round(decay_list_final,2)))
    else:    
        print("\nBased on the information you entered, your chances of getting at least one offer are: " \
              + str(round(dream_percentage,2)))
    print("\nThe overall chance of getting 3 or more offers is: " + \
          str(round(1 - (comb(applications, 2) * np.mean(decay_list)**2 * (1-np.mean(decay_list))**(applications-2) \
                         + comb(applications, 1) * np.mean(decay_list) * (1-np.mean(decay_list))**(applications-1) \
                         + (1-np.mean(decay_list))**applications),2)))

jobs()

