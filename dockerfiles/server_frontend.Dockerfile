# Step 1: Use an official Node.js runtime as a parent image
FROM node:14 as build

# Step 2: Set the working directory in the container
WORKDIR /app

# Step 3: Copy the package.json files from your project into the container
COPY im_server/frontend/package*.json ./

# Step 4: Install any dependencies npm是Node Package Manager npm install 安装package.json文件中列出的依赖项
RUN npm config set registry https://registry.npmmirror.com && npm install

# Step 5: Copy the rest of your app's source code from your project into the container
COPY im_server/frontend .

# Step 6: Your app binds to port 3000 so you'll use the EXPOSE instruction to have it mapped by the docker daemon
# EXPOSE 3000

# Step 7: Define the command to run your app using CMD which defines your runtime
# CMD ["npm", "run", "build"]
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:alpine
#从之前命名为build的构建阶段复制构建好的前端应用到Nginx服务器的Web根目录。
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
#定义容器启动时执行的命令，这里启动Nginx服务器，-g参数用于配置Nginx的运行模式，这里设置为非守护进程模式。
CMD ["nginx", "-g", "daemon off;"]
