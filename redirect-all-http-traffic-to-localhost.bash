# define a function to redirect all HTTP traffic to localhost:5000
function redirect_http()
{
  # redirecting your HTTP traffic to localhost:5000 (the gunicorn port)
  sudo iptables -I INPUT -p tcp --dport 80 -j REDIRECT --to-port 5000
}

# define a function to redirect all HTTPS traffic to localhost:5000
function redirect_https()
{
  # redirecting your HTTPS traffic to localhost:5000 (the gunicorn port)
  sudo iptables -I INPUT -p tcp --dport 443 -j REDIRECT --to-port 5000
}

# define a function to redirect all HTTP and HTTPS traffic to localhost:5000
function redirect_all()
{
  # redirecting your HTTP traffic to localhost:5000 (the gunicorn port)
  sudo iptables -I INPUT -p tcp --dport 80 -j REDIRECT --to-port 5000

  # redirecting your HTTPS traffic to localhost:5000 (the gunicorn port)
  sudo iptables -I INPUT -p tcp --dport 443 -j REDIRECT --to-port 5000
}

# define a function to remove the redirect rules
function remove_redirect()
{
  # removing the redirect rules
  sudo iptables -D INPUT -p tcp --dport 80 -j REDIRECT --to-port 5000
  sudo iptables -D INPUT -p tcp --dport 443 -j REDIRECT --to-port 5000
}

# define a function to start gunicorn
function start_gunicorn()
{
  # starting gunicorn
  sudo gunicorn --bind 127.0.0.1:5000 wsgi:app
}

# declare a list of options
declare -a options=(
  "0 - Exit"
  "1 - Enable reverse proxy for HTTP traffic (port 80)"
  "2 - Enable reverse proxy for HTTPS traffic (port 443)"
  "3 - Enable reverse proxy for HTTP and HTTPS traffic"
  "4 - Remove redirect rules"
  "5 - Start gunicorn"
)

# print the options
printf "Choose an option:\n"
for option in "${options[@]}"; do
  printf "%s\n" "$option"
done

# read the option from the user
read -p "Enter the option number: " option

# check the option and call the required function
case $option in
  1)
    redirect_http
    ;;
  2)
    redirect_https
    ;;
  3)
    redirect_all
    ;;
  4)
    remove_redirect
    ;;
  5)
    start_gunicorn
    ;;
  0)
    exit 0
    ;;
  *)
    printf "Wrong option entered\n"
    exit 1
    ;;
esac
