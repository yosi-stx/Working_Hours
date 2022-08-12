# to get the date and time like in Aggregate_working_Hours.txt
import datetime as DT
from datetime import date

day_string = {0:"Monday", 1:"Tuesday", 2:"Wednesday", 3:"Thursday", 4:"Friday",5:"Saturday", 6:"Sunday"}
today = DT.date.today()

# finding last week date
st =week_ago = today - DT.timedelta(days=7)
s1 = str(st)  # the date 7 days ago (last week)
last_week = s1.replace("-","_")
# finding last monday date
# since Monday==0, delta of [today.weekday()] returns Mondays date
st = today - DT.timedelta(days=today.weekday())
s1 = str(st)  # the date 7 days ago (last week)
last_monday = s1.replace("-","_")
st = today - DT.timedelta(days=(today.weekday()+7))
s1 = str(st)  # the date 7 days ago (last week)
last_2_monday = s1.replace("-","_")

print("----------------------")
print("last_week: ", last_week)
print("last_monday: ", last_monday)
print("----------------------")
# exit()

# my_file = "C:\\Users\\Owner\\open_explorer_folder_list.txt"
# my_file = "C:\\Users\\Owner\\open_explorer_folder_list.txt"
my_file = "C:\\AHK\\Aggregate_working_Hours.txt"

line_no = 0
# print(list(open(my_file)))
# exit()
# // this doesn't work if you can't fit the whole file in memory.
for line in reversed(list(open(my_file))):
    # print(line.rstrip(),end="          >")
    # if not ("reloaded" or "line") in line :
    if "reloaded" not in line and "Line" not in line:
        line_date = line[0:10]
        line_print = line_date + " " #+"\n"
        a = line.split("_")
        line_st = a[0] + "_" + a[1] + "_" + a[2]
        line_st2 = a[0] + "-" + a[1] + "-" + a[2]
        # 2022_07_26
        if (line_date >= last_monday):
            print(line_print,end=".")
            print(day_string[date(int(a[0]), int(a[1]), int(a[2])).weekday()])
            last_monday_count = line_no
        else:
            if (line_date > last_week):
                print(line_print, end="")
                print(day_string[date(int(a[0]), int(a[1]), int(a[2])).weekday()])
                last_week_count = line_no
            else:
                if (line_date >= last_2_monday):
                    print(line_print, end="")
                    print(day_string[date(int(a[0]), int(a[1]), int(a[2])).weekday()])
                else:
                    print("working hours from last 2 Monday: ", line_no/12) # by 8.5 working hours a day
                    print("working Days from last 2 Monday : ", line_no/102)
                    print("working hours from last week: ", last_week_count/12) # by 8.5 working hours a day
                    print("working Days from last week : ", last_week_count/102)
                    print("working hours from last Monday: ", last_monday_count/12) # by 8.5 working hours a day
                    print("working Days from last Monday : ", last_monday_count/102)
                    break
        line_no += 1
        # print(".", end=" ")
        # if line_no > 150:
        #     break
    # print(">")
print("----------------------")
print("last_week: ", last_week)
print("last_monday: ", last_monday)
print("last_2_monday: ", last_2_monday)
print("----------------------")
