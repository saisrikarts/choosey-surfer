"""

This python library spits out the common values from 3 lists

"""

list1 =[""]
list2 =[""]
list3 =[""]
list4 =[""]
list5 =[""]
list6 =[""]

def   get_common_values_from_three_lists(list1,list2,list3):
    """

    :param list1:
    :param list2:
    :param list3:
    :return commonlist:
    """
    common = set(list1) & set(list2) & set(list3)
    return common


def get_common_values_from_two_lists(list1,list2):
    """

    :param list1:
    :param list2:
    :return:
    """
    common = set(list1) & set(list2)
    return common
