Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC937FD
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 00:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BBv9tJ05"
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C36F1BF
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 Nov 2023 16:06:51 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cc329ce84cso46191745ad.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 06 Nov 2023 16:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699315611; x=1699920411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s3lHltmHAT3Zjs2Or9HI9VhRMd3mEFK2uKST2wN2rlk=;
        b=BBv9tJ05TyDM6ruq5aLaQG6bBpSjbAi22255S4eTkR3+Wt6CCj6eLdFORVXaj4cAIS
         e8Qp6m2gtuaiKUBIurLBSJ8m1k95L24J0an7pbMqNr8aAk8yj1MsUaedccNQ8NbexXPX
         DbG9xbQzCBsAgdjSupa4nzqhER4PMH0zyur0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699315611; x=1699920411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3lHltmHAT3Zjs2Or9HI9VhRMd3mEFK2uKST2wN2rlk=;
        b=YzQyk2A85yed1efLRvjmh3JvjxU7hyx6in4+7exlfJqHmglM7H3NtJ6Y6slDdBKHu0
         Pgmn8VYHSrXVRMId3JUaGGZFeGskdht0wGURjjaHsIjeLpVcF5k1EkXvumI7dPB1X2l7
         7NCgY54JzP/PAUDJn3xYrXnxIEqpYuHTUWiwnFx+utdMSrZ8Szgqe9tC0gyzqOIGnTGi
         VqbFkGLZDFrPF/QqoVJpxFRAcRFckC30z1HXl+4sxCkiLvsgDnTFXsDyTH3NiiDaI+mO
         nd5Ssq/K/0wnaUwfGL62QBz88DH03IWCndWIGWQXjTCoXSboAo3SsDjhejSCY74eArTv
         mNpA==
X-Gm-Message-State: AOJu0Ywzvu/hzVQxvuqwfI4NB3f78GT80bdGbyNaXvxci+o9w+I++gvc
	5Zqfu27+DLRyiD3uILjzINyIcg==
X-Google-Smtp-Source: AGHT+IE9z6AcBHk9ED2kB1KouwueOG1tOWlEHOZOuaUzdUabyJxe5oUCUNA4++KR+8Vk6f8c04Ot/w==
X-Received: by 2002:a17:903:2594:b0:1c6:117b:7086 with SMTP id jb20-20020a170903259400b001c6117b7086mr27742336plb.5.1699315610900;
        Mon, 06 Nov 2023 16:06:50 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090276c900b001ca82a4a9c8sm6307809plt.269.2023.11.06.16.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 16:06:50 -0800 (PST)
Date: Mon, 6 Nov 2023 16:06:49 -0800
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] bcachefs: Fix multiple -Warray-bounds warnings
Message-ID: <202311061606.29DB1C09@keescook>
References: <ZUldRv35EXKHAt3L@work>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUldRv35EXKHAt3L@work>

On Mon, Nov 06, 2023 at 03:40:22PM -0600, Gustavo A. R. Silva wrote:
> Transform zero-length array `entries` into a proper flexible-array
> member in `struct journal_seq_blacklist_table`; and fix the following
> -Warray-bounds warnings:
> 
> fs/bcachefs/journal_seq_blacklist.c:148:26: warning: array subscript idx is outside array bounds of 'struct journal_seq_blacklist_table_entry[0]' [-Warray-bounds=]
> fs/bcachefs/journal_seq_blacklist.c:150:30: warning: array subscript idx is outside array bounds of 'struct journal_seq_blacklist_table_entry[0]' [-Warray-bounds=]
> fs/bcachefs/journal_seq_blacklist.c:154:27: warning: array subscript idx is outside array bounds of 'struct journal_seq_blacklist_table_entry[0]' [-Warray-bounds=]
> fs/bcachefs/journal_seq_blacklist.c:176:27: warning: array subscript i is outside array bounds of 'struct journal_seq_blacklist_table_entry[0]' [-Warray-bounds=]
> fs/bcachefs/journal_seq_blacklist.c:177:27: warning: array subscript i is outside array bounds of 'struct journal_seq_blacklist_table_entry[0]' [-Warray-bounds=]
> fs/bcachefs/journal_seq_blacklist.c:297:34: warning: array subscript i is outside array bounds of 'struct journal_seq_blacklist_table_entry[0]' [-Warray-bounds=]
> fs/bcachefs/journal_seq_blacklist.c:298:34: warning: array subscript i is outside array bounds of 'struct journal_seq_blacklist_table_entry[0]' [-Warray-bounds=]
> fs/bcachefs/journal_seq_blacklist.c:300:31: warning: array subscript i is outside array bounds of 'struct journal_seq_blacklist_table_entry[0]' [-Warray-bounds=]
> 
> This results in no differences in binary output.
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks; that looks right to me.

-Kees

-- 
Kees Cook
