library(data.table)
library(dplyr)
library(ggplot2)

# Download datasets (Territory-specific data (200Kb))
url = "https://www.ssa.gov/OACT/babynames/limits.html"
setwd("/Users/jessymin/Documents/Github/usa_name_trend/names")


filepath = "/Users/jessymin/Documents/Github/names"
file_list = dir()
l = length(file_list)


# Read data
df<-data.frame()

for (i in (1:l)) {
  data <- fread(file_list[i], 
                colClasses=c("character", "character", "integer"))
  data$year <- substr(file_list[i], 4, 7)
  df <- rbind(df, data)
  rm(data)
}

rm(filepath, file_list, i, l)



# 컬럼명 추가
colnames(df) <- c("name", "gender", "count", "year")



# 컬럼타입 변경
df$gender <- as.factor(df$gender)
df$year <- as.numeric(df$year)



# 출현빈도 정규화하기

df <- df %>% 
      group_by(gender, year) %>%
      mutate(group_sum = sum(count))

df <- df %>%
      mutate(norm = count/group_sum*100) %>%
      select(-group_sum)



# 각 연도별로 랭킹 추가
df <- df %>% arrange(gender, year, desc(count))

df <- df %>%
          group_by(gender, year) %>%
          mutate(rank = dense_rank(-count))



# 3년전과 랭킹 비교위해 조인하기
df2 <- df
df$year_before_3 <- df$year - 3

df <- left_join(df, df2, by = c('gender'='gender', 'year_before_3'='year', 'name'='name')) 
df <- filter(df, year >= 1963)
df <- df %>% select(-year_before_3, -count.y, -norm.y)

colnames(df) <- c('name','gender','count','year','norm','rank','rank_previous')



# 랭크에 신규 진입한 이름은 임의값(10,000)을 이전 랭킹으로 부여
df[is.na(df$rank_previous),]$rank_previous <- 10000



# 랭킹 변화 표시
df$rank_up <- df$rank_previous - df$rank

df <- df %>% 
      mutate(status = case_when (
              rank_up > 0 ~ "▲",
              rank_up == 0 ~ "-",
              rank_up < 0 ~ "▽"
              )
            )



# 컬럼 순서 재정렬
df <- df %>% select(6, 9, 8, 1:5, 7)

  

# 파일 저장
write.csv(df, 'usa_names_1963_current.csv', row.names=F)


