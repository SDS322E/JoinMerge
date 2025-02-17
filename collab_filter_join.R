################################################################################
## Build collaborative filtering system using joins

## Amazon review data
amazon <- read_tsv("https://github.com/rdpeng/stat322E_public/raw/main/data/amazon_reviews_us_Digital_Software_v1_00.tsv.gz",
                   col_types = "cccccccdddccccD")
amazon

## Subset the data
dat <- amazon |> 
    select(customer_id, 
           product_id, 
           product_title,
           star_rating,
           review_headline) |> 
    rename(rating = star_rating)
dat

## Find users that have more than 1 review
users <- dat |> 
    group_by(customer_id) |> 
    summarize(n = n()) |> 
    filter(n > 1)
users

## Find products that have more than 2 reviews
products <- dat |> 
    group_by(product_id) |> 
    summarize(n = n()) |> 
    filter(n > 2)
products

## Inner join the original data with the 'users' and 'products' tables
ratings <- dat |> 
    inner_join(users, by = "customer_id") |> 
    inner_join(products, by = "product_id")
ratings

## Sample a product review
set.seed(2023-02-12)
original <- ratings |> 
    sample_n(1) |> 
    select(customer_id, product_id, rating, product_title)
original

## Find products reviewed by other customers
ratings |> 
    # Find other customers who reviewed this
    inner_join(original |> 
                   select(product_id), 
               by = "product_id") |> 
    # Remove original reviewer
    anti_join(original |> 
                  select(customer_id), 
              by = "customer_id") |>   
    select(customer_id) |> 
    # Join with all data to get other products
    left_join(dat, by = "customer_id") |>  
    # Remove the original product
    anti_join(original |> 
                  select(product_id), 
              by = "product_id") |> 
    # Only keep products with 5-star ratings
    filter(rating == 5) |> 
    select(customer_id, product_id, rating, product_title)













