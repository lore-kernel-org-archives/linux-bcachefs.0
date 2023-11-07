Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B667FD
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 00:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ft2gnIOw"
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CFEBD
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 Nov 2023 16:08:01 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6bee11456baso4714203b3a.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 06 Nov 2023 16:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699315681; x=1699920481; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpBfLqGQ1VKrTJ3rcs4fBikFzF1QxsAIPWYX8n9C+y0=;
        b=Ft2gnIOwSF3Ap0pd8Y1sbge0ZRB+J81+y0RvxcnpMVwcUeRC6cC61fKOUs7GiqGh4Y
         C0hxzu5YEhfJtW2eKWfAeufgWcPvtSPqCc8IxjpLAd+dhhAOGFZUeb2vEN5/tFxdizN4
         j/l+iXo+M6WXhP6u1aMGQ3Cnh+WE5ypXNyqHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699315681; x=1699920481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpBfLqGQ1VKrTJ3rcs4fBikFzF1QxsAIPWYX8n9C+y0=;
        b=Mofl0jkcfe2a+KYnf37q1ehMpEuJUpMQITzY4pWo52xMuAkUZDMdn6uFuAsIBSDUtG
         Cv90hvisehHtJWV3ByhlE1qytuOHfzMU1t7lxRZjXEVS4oE2+ZsFya0+KeHrsPOxErzm
         kw916cC39FR54Aqy/QskCL8pgKrsLDsbnmD4BsY3OHRRg3oGX088xeDN9Db0ahdNa+4i
         doK09SSUIcMvR69ibulG/KhTvLhw98JpyxbgRSCHHnKreH5ZZRVFweAeJPH1HKQ9e73K
         CAXUBS8n3IxMvHazzpCX4BqsqucoeiPhXHHq3C5iDyWpA50KvUriRJs66uq03HDb5CzK
         MSpw==
X-Gm-Message-State: AOJu0YxNvx0ps1abb/BIbRQJ6gogXXY+uE3Lb9i14UH3IkuHX1dEvgVK
	+TEJ5GrudmpVLjNBODfuJ3byKw==
X-Google-Smtp-Source: AGHT+IGoYzR5kL2w+NjsZnBpueTqNLfZQcNpHmvWNnj8GRYy6lyod5A9USfm/k9J1c/4hIUoODiRdA==
X-Received: by 2002:a05:6a00:244b:b0:68e:496a:7854 with SMTP id d11-20020a056a00244b00b0068e496a7854mr27793278pfj.18.1699315681060;
        Mon, 06 Nov 2023 16:08:01 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id r8-20020aa78448000000b0064f76992905sm6076788pfn.202.2023.11.06.16.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 16:08:00 -0800 (PST)
Date: Mon, 6 Nov 2023 16:08:00 -0800
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] bcachefs: Use DECLARE_FLEX_ARRAY() helper and fix
 multiple -Warray-bounds warnings
Message-ID: <202311061607.FFD1D68@keescook>
References: <ZUloNt0HSulJgZNH@work>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUloNt0HSulJgZNH@work>

On Mon, Nov 06, 2023 at 04:27:02PM -0600, Gustavo A. R. Silva wrote:
> Transform zero-length array `s` into a proper flexible-array
> member in `struct snapshot_table` via the DECLARE_FLEX_ARRAY()
> helper; and fix tons of the following -Warray-bounds warnings:
> 
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.c:135:70: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  fs/bcachefs/subvolume_types.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/subvolume_types.h b/fs/bcachefs/subvolume_types.h
> index 86833445af20..2d2e66a4e468 100644
> --- a/fs/bcachefs/subvolume_types.h
> +++ b/fs/bcachefs/subvolume_types.h
> @@ -20,7 +20,7 @@ struct snapshot_t {
>  };
>  
>  struct snapshot_table {
> -	struct snapshot_t	s[0];
> +	DECLARE_FLEX_ARRAY(struct snapshot_t, s);
>  };

Yup, this is the current way forward for 0-to-flex transformations in
unions or alone in structs (until it's supported correctly by GCC and
Clang, which is in progress).

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
