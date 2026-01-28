# pip install streamlit
# streamlit run chat.py
# From tutorial: "Build a chatgpt like app" on Streamlit website

import streamlit as st
from openai import OpenAI
import os
from main import run

st.title("Chat with IMDb")

# Set OpenAI API key from Streamlit secrets
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Set a default model
if "openai_model" not in st.session_state:
    st.session_state["openai_model"] = "gpt-5.2"

# Initialize chat history
if "messages" not in st.session_state:
    st.session_state.messages = []

# Display chat messages from history on app rerun
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Accept user input
if prompt := st.chat_input("What is up?"):
    # Add user message to chat history
    st.session_state.messages.append({"role": "user", "content": prompt})
    # Display user message in chat message container
    with st.chat_message("user"):
        st.markdown(prompt)

if st.session_state.messages:
    # Display assistant response in chat message container
    with st.chat_message("assistant"):
        response = run(
            prompt, st.session_state["openai_model"], st.session_state.messages
        )
        response = st.write(response)
    st.session_state.messages.append({"role": "assistant", "content": response})
