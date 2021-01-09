# -*- coding: utf-8 -*-
"""
Created on Sat Jun 20 17:04:11 2020

@author: Wesley
"""

import numpy as np
import os
from urllib import request
import nltk
import re

AllTokens = []
MCMatrix = None
headings = ["xix","xxiv","xxiii","xxii","xxi","xx","xviii","xvii","xvi","xv","xiv","xiii","xii","xi","viii","vii","iv","vi","iii","ii","ix"," x "," v ","--"]
def text_from_gutenberg(title, author, url, path = 'corpora/', return_raw = False, return_tokens = True):
    # Convert inputs to lowercase
    def find_beginning_and_end(raw):
        '''
        This function serves to find the text within the raw data provided by Project Gutenberg
        '''
        
        start_regex = '\*\*\*\s?START OF TH(IS|E) PROJECT GUTENBERG EBOOK.*\*\*\*'
        draft_start_position = re.search(start_regex, raw)
        begining = draft_start_position.end()
    
        if re.search(title.lower(), raw[draft_start_position.end():].lower()):
            title_position = re.search(title.lower(), raw[draft_start_position.end():].lower())
            begining += title_position.end()
            # If the title is present, check for the author's name as well
            if re.search(author.lower(), raw[draft_start_position.end() + title_position.end():].lower()):
                author_position = re.search(author.lower(), raw[draft_start_position.end() + title_position.end():].lower())
                begining += author_position.end()
        
        end_regex = 'end of th(is|e) project gutenberg ebook'
        end_position = re.search(end_regex, raw.lower())
    
        text = raw[begining:end_position.start()]
        for x in "@#$%^&_<>/=;":
            text = re.sub(x,"",text)
        return text.lower()
    
    title = title.lower()
    author = author.lower()
   
    # Check if the file is stored locally
    filename = 'corpora/' + title
    if os.path.isfile(filename) and os.stat(filename).st_size != 0:
        print("{title} file already exists".format(title=title))
        print(filename)
        with open(filename, 'r') as f:
            raw = f.read()
        
    else:
        print("{title} file does not already exist. Grabbing from Project Gutenberg".format(title=title))
        response = request.urlopen(url)
        raw = response.read().decode('utf-8-sig')
        print("Saving {title} file".format(title=title))
        with open(filename, 'w') as outfile:
            outfile.write(raw)
            
    if return_raw:
        return find_beginning_and_end(raw)
    
    # Option to return tokens
    if return_tokens:
        return nltk.word_tokenize(find_beginning_and_end(raw))
    
    else:
        return find_beginning_and_end(raw)

def CreateMC(WordMapping):
    # Creates the giant matrix, but in dictionary format to decrease spatial and temporal complexity
    data={k:{-1:1} for k in range(1,len(WordMapping)+1)}
    data[0] = {k:0 for k in range(1,len(WordMapping)+1)}
    for i in range(1,len(AllTokens)):
        regex = re.compile('@_!#$%^&<>?/\|~:;')
        idxs = (WordMapping[AllTokens[i-1]],WordMapping[AllTokens[i]])
        if '.' in AllTokens[i] or '?' in AllTokens[i] or '!' in AllTokens[i]:
            data[idxs[0]][-1] += 1
            continue
        elif '.' in AllTokens[i-1] or '?' in AllTokens[i-1] or '!' in AllTokens[i-1]:
            data[0][idxs[1]] += 1
            continue
        if (regex.search(AllTokens[i]) != None): 
            continue
        if idxs[1] not in data[idxs[0]]:
            data[idxs[0]][idxs[1]] = 1
        data[idxs[0]][idxs[1]]+=1
            
    return data

def getData():
    # Gets the data, builds the word to index mappings, and the markov chain.
    global AllTokens
    titles = ["A Tale of Two Cities",'Our Mutual Friend', "Oliver Twist", "A Christmas Carol",'Bleak House','The Pickwick Papers']
    author = 'Charles Dickens'
    urls = ["http://www.gutenberg.org/files/98/98-0.txt",
            "http://www.gutenberg.org/files/883/883-0.txt",
            'http://www.gutenberg.org/cache/epub/730/pg730.txt',
            'http://www.gutenberg.org/cache/epub/19337/pg19337.txt',
            'http://www.gutenberg.org/cache/epub/1023/pg1023.txt',
            'http://www.gutenberg.org/files/580/580-0.txt']
    j = 0
    WordMapping ={}
    ReverseMapping ={}
    for i in range(len(titles)):
        tokens = text_from_gutenberg(titles[i],author,urls[i])
        tokens = [x for x in tokens if x not in headings and x !='v' and x != 'x']
        for word in tokens:
            if word not in WordMapping:
                WordMapping[word]=j+1
                ReverseMapping[j+1]=word
                j+=1
        AllTokens += tokens
    
    data = CreateMC(WordMapping)
    return ReverseMapping,data

def SampleData(reversemapping,datadict,n_sentences=10):
#    reversemapping = np.load("reversemapping.npy")
#    datadict = np.load("datadict.npy")
    # and is index 147
    # time is index 1105
    i = 0
    idx=0
    finalstr = []
    while i < n_sentences:
        probs = np.array([datadict[idx][x] for x in datadict[idx]])
        idx = np.random.choice(np.arange(0,len(datadict[idx])),size=1,p=probs/np.sum(probs))[0]
        if idx == 0:
            if len(finalstr) < 2:
                finalstr = []
                idx = 0
                continue
            i+=1
            finalstr.append('\n')
            print("==>Sentence {}".format(i))
            print(" ".join(finalstr))
            finalstr = []
            continue
        finalstr.append(reversemapping[idx])
    return

if __name__=='__main__':
    r,d = getData()
    SampleData(r,d)