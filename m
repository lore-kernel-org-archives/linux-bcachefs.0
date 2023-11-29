Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hcdfwa4T"
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA8FD7F
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 12:15:48 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-5c5f0e325a6so138944a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 12:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701288948; x=1701893748; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jotP4vYpPJo//cpTI3uXY4V9lpzWkYj/fK6F2WyIseA=;
        b=hcdfwa4TYcjUsd4YezCO6cbH/PkKleuvxCuGnZoxGifuXLSJvfQZOm/1KrNR32M4CY
         TzKCy+vq+86ljb5r9bxSkTOK/rwW8sUqP023BbJ0FDV+beFBFTstZ49SRNuEFe99uSdW
         2K3KvdnptVVMNAWbLYfloZ86JP7odnEBhv8pI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701288948; x=1701893748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jotP4vYpPJo//cpTI3uXY4V9lpzWkYj/fK6F2WyIseA=;
        b=Of7iRjTBxN2BcBtbqSIVMa8B/53SHkA/ng0eUgXbpB3fMKwIe1S5Oca28p2J0+Ti2o
         GFTBAlRV5McIMIDB6iGC1neeiqsjIKXVUCWXqDnE1e034m+aWvFUcublCFuUXNr0kWTo
         2ahG56ycrSruBmkKr6MCOZo2UvMFatHD3U3IZh5el1yAfLgjC6qF1dW14umY/o/dOoQ2
         7bWFb1kCitTwWPQv7WYdzQ6OaXae4xCa93/eGzhokg014IgGUh1F36hDd2DKlVi1pIrw
         8a0tqyjfBnIPbWJnA03t+ELy2an8WvpkNl1l7m6dKx7nKiwHyagQ4MPSAIRWUJXCSE7d
         uDoA==
X-Gm-Message-State: AOJu0YypkcjagvK19N63HKUx1zkrW0khVZsEe0xpI03Bf6H3p/HF2gA6
	+sTlsmUxPm7DW0bcBwBfMng1UQ==
X-Google-Smtp-Source: AGHT+IG534o8LlbEMOfFzpwYToM7hK+n/JXeWeW9JF2pDdVckMCGK6vCE97PcNRJj6shzwBCP8zRfA==
X-Received: by 2002:a05:6a20:e113:b0:18c:5c04:a55e with SMTP id kr19-20020a056a20e11300b0018c5c04a55emr17283060pzb.49.1701288947811;
        Wed, 29 Nov 2023 12:15:47 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id v15-20020aa7850f000000b006cde291d429sm194972pfn.39.2023.11.29.12.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 12:15:47 -0800 (PST)
Date: Wed, 29 Nov 2023 12:15:46 -0800
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] bcachefs: Replace zero-length arrays with
 flexible-array members
Message-ID: <202311291215.9BBCD8E@keescook>
References: <ZWYv/ywR/qxUhVSU@work>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWYv/ywR/qxUhVSU@work>

On Tue, Nov 28, 2023 at 12:22:55PM -0600, Gustavo A. R. Silva wrote:
> Fake flexible arrays (zero-length and one-element arrays) are
> deprecated, and should be replaced by flexible-array members.
> 
> So, replace zero-length arrays with flexible-array members
> in multiple structures.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

These look like straight-forward conversions. Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
