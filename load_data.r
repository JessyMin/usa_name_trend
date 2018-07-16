library(readr)
library(dplyr)
library(ggplot2)


url = "https://www.ssa.gov/OACT/babynames/limits.html"
setwd("/Users/jessymin/Documents/usa_name_trend/namesbystate")
filepath = '/Users/jessymin/Documents/usa_name/namesbystate'

file_list = dir()

l = length(file_list)

df<-data.frame()


# 읽기 테스트
df3 <- read_csv("AK.TXT", col_types = cols(
    state = "c",
    gender = "c",
    year = "i",
    name = "c",
    number = "i"),
    col_names = F
)

# 테스트
df4 <- read.csv("AK.TXT", colClasses = c("factor","factor", "integer", "character", "integer"), header=F)
df5 <- read_csv("AK.TXT", col_names = F)

#진짜 오래걸림. 
#readr 사용해서 성능개선 필요하지만, F를 False로 읽는 문제 해결 못함.
for (i in (1:length(file_list))) {
        data <- read.csv(file_list[i], 
                         colClasses = c("factor","factor", "integer", "character", "integer"),
                         header=F)
        df <- rbind(df, data)
        rm(data)
}



rm(file_list, i, l)

colnames(df) <- c('state', 'gender', 'year', 'name', 'number')

#파일 저장
write.csv(df, 'usa_names_1910_current.csv', row.names=F)





# 연도 추출

df <- filter(df, year >= 1970)

#1970년 이후만 저장.
write.csv(df, 'usa_names_1970_current.csv', row.names=F)


df2 <- filter(df, year >= 1980)
write.csv(df2, 'usa_names_1980_current.csv', row.names=F)

# 샘플 테이블 만들기 : 1980~1983년, 남/녀
sample <- df2 %>% filter(year %in% c(1980:1983)) %>%
                group_by(year, gender, name) %>%
                summarise(count = sum(number)) %>%
                arrange(year, gender, desc(count))

write.csv('sample.csv', row.names=F)


# 시험삼아, 1981년 이름 추출해보기 / 순위 매기기

df_1981 <- df %>% 
                filter(year == 1981 & gender == 'F') %>%
                group_by(name) %>%
                summarise(count = sum(number)) %>%
                arrange(desc(count)) %>%
                mutate(ranks = rank(-count))

head(df_1981)

#1978년 추출

df_1976 <- df %>% 
        filter(year == 1976 & gender == 'F') %>%
        group_by(name) %>%
        summarise(count = sum(number)) %>%
        arrange(desc(count)) %>%
        mutate(ranks = rank(-count))

# 시험삼아, 1981년 이름 추출해보기 / 순위 매기기

df_1990 <- df %>% 
        filter(year == 1990 & gender == 'F') %>%
        group_by(name) %>%
        summarise(count = sum(number)) %>%
        arrange(desc(count)) %>%
        mutate(ranks = rank(-count))

head(df_1990)



# 조인하기
df1 <- left_join(df_1981, df_1976, by = c('name'='name')) 

colnames(df1) <- c('name','count','rank','count_previous','rank_previous')
df1 <- df1 %>%
                mutate(status = case_when(
                                        df1$rank < df1$rank_previous ~ 'rising',
                                        df1$rank == df1$rank_previous ~ 'equal',
                                        df1$rank > df1$rank_previous ~ 'falling'
                                        )) 

df1 <- mutate(df1, rank_up = rank_previous - rank)
df1 <- mutate(df1, status = case_when (
                                df1$rank_up > 0 ~ 'rising',
                                df1$rank_up == 0 ~ 'staying',
                                df1$rank_up < 0 ~ 'falling'))

df1 <- select(df1, -c(count_previous,rank_previous))


# 여자 이름 추세 보기
f_df <- filter(df, gender == 'F')
female_name_list <- sort(unique(f_df$name))
female_name_list                        
Jackie
Jaclyn
Jamie
Jane
Jasmin
Jean
Jenifer
Jenny
Jennifer
Jessica
Jessie
Joyce
Julie

list <- c('Jackie','Jaclyn','Jamie','Jane','Jasmin','Jean','Jenifer','Jenny', 
          'Jessica','Jessie','Joyce', 'Julie')

list <- c('Jessica','Maggie','Maria','Martha','Mary','Mia','Mika')
      
#1981년 랭킹중 마음에 드는 것들          
list <- c('Jennifer','Jessica','Michelle','Rebecca','Tiffany',
          'Angela','Kelly','Jamie','Erica','Monica','Anna','Jill')
#아..전체적으로 출산율 줄어드는 듯? 정규화 필요함. 


g <- f_df %>% 
        filter(name %in% list) %>%
        group_by(year, name) %>%
        summarise(count = sum(number)) 

ggplot(g, aes(year, count, col=name)) + 
                geom_line() + 
                scale_color_manual(values=pal)

pal <- c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928')


# 전체 n수는? 출산율 증감 추이는?

df_summary <- df %>% 
                group_by(year, gender) %>%
                summarise(count = sum(number))

ggplot(df_summary, aes(year, count, fill=gender)) +
                geom_bar(stat='identity', position=position_dodge())


# 같이 그린 그래프
ggplot(NULL, aes(year, count)) +
        geom_line(data = filter(df_summary, gender=='F')) +
        geom_line(data = g, aes(col=name))


# 정규화를 해보자. 비율로.
# 1981년의 Jessica가 몇 명인지와, 1976년의 Jessica 명수는 직접적인 비교가 불가능하다. 
# 모집단의 수가 다르기 때문이다. 

g <- f_df %>% 
        filter(name %in% list) %>%
        group_by(year, name) %>%
        summarise(count = sum(number)) 

n_1981 <- f_df %>% filter(year == '1981') %>%
        summarise(sum(number))

n_1981 <- unlist(n_1981)        

g <- g %>% mutate(count2 = count/n_1981)


ggplot(g, aes(year, count2, col=name)) + 
        geom_line() + 
        scale_color_manual(values=pal)





test <- data.frame(
        year = c(1980,1980,1980,1981,1981,1981),
        name = c('a','b','c','a','b','c'),
        count = c(10,20,30,50,80,90)
)

test1 <- test %>%
        group_by(year) %>%
        mutate(sum_year = sum(count))
test1 <- test1 %>%
        mutate(count_norm = count/sum_year*100) 
test1

ggplot(test1, aes(col=name)) + 
        #geom_line(aes(year, count)) +
        geom_line(aes(year, count_norm)) +
        scale_x_continuous(breaks=c(1980,1981))

###### R programming

plus <- function(x, y){
    result = x + y
    return(result)
}

###### 해당 연도의 인기 이름을 30위까지 보여줌

year_gender <- function(y, g){
    df_y = filter(df, gender == g) %>%
        filter(year == y) %>%
        group_by(name) %>%
        summarise(count = sum(number))
    
    df_y = df_y %>%
        mutate(ranks = rank(-count)) %>%
        mutate(total = sum(count)) %>%
        filter(ranks < 31) %>%
        arrange(ranks)
    
    g = ggplot(df_y, aes(name, count)) + geom_bar(stat='identity') + coord_flip()
    
    
    return(g)
}

sample <- filter(df, year %in% c(1980:1983))
sample <- sample %>% group_by(year, name) %>% summarise(count = sum(number))
sample <- sample %>% filter(count > 40000)
write.csv(sample, "sample.csv", row.names=F)
