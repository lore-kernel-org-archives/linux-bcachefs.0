Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4171B182A0
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KpVJeo1N"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bf0f3bf331so135668739f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 09:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705341454; x=1705946254; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=esylDQYZzJyJRhr7C3pusjJWVg1ZBRVzenuewnNyNuc=;
        b=KpVJeo1NSAcQ9PEbFU9zl8OUNi5OGRFDgZxyoBUMv80jp+7B+E//X1svUC3jNXktAj
         w8xVRqBCSRRvnNqPRAeefw5qLsQWS+/zkZca6x5K/Xt7H3nFabpIrdVGLjhp3YwF6emm
         oLOuZZSjbG5WkBqVWQ3LT2wqLhIX/JCf5GG/RFoT9bs9s4JoMy9z7bANH9E55uiQrsfr
         mMOO4mefEx77UOtpJqvkdbLslr/nxiVoBALE6JeDgKb3z/H1A7BZC793FpG4r2kby2B7
         VAQQCEtCsx1dfXNxAbMhEnra7G3b2o6HZhAMLHBIXjht8A1HWX90UjyzybYNA0d/ED/d
         f7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705341454; x=1705946254;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esylDQYZzJyJRhr7C3pusjJWVg1ZBRVzenuewnNyNuc=;
        b=VRpj8aleffXQf5hUPhMAPs0U9nmULI0eZCdUIXMDaDGQCSssieYW175a6K+mCBqqLl
         FP4yw91E7aOfAZF0m5b9GQw1JokcOWAxWK3aPxz0b+PCK/gZTytgvwzMg5pvWCj8YP4I
         ODSzNBD13Q5tnp1FyKWYjApunAMBc/NWWbING4HtGQb/RBtcMmhUlKMZHCCAfIssT9aM
         Nhu+IwZmY7NOYOAnDSFB70Dg5LpxQJ/fNnwqKCi4pSSQAsr8Ip7YoaQtqfk3QSRwOoUf
         SMFE/3BjKCP7KdZC44F9K5sz6dxqM3WazeqCB3BF7qvmSTDOgIiObM1A2XRmca+IXiff
         WQsw==
X-Gm-Message-State: AOJu0Yx0QqwyehNE6XiX5Xy+GwkhvFpTMaFT4KCmA0qIZr3J0Kbfe8BW
	JzgG03BYlWBL2PTUGd36rTw=
X-Google-Smtp-Source: AGHT+IEKQGQsQC6E+sc3f/5enNtlgsEfNvF0UD4FjwRkl7sEjRya7VLwJphyGenhrnSFLC3ixxl9Iw==
X-Received: by 2002:a05:6602:490f:b0:7bf:4735:7123 with SMTP id ef15-20020a056602490f00b007bf47357123mr1890681iob.20.1705341454312;
        Mon, 15 Jan 2024 09:57:34 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id y6-20020a6be506000000b007bf5113d0acsm230994ioc.2.2024.01.15.09.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 09:57:33 -0800 (PST)
Date: Mon, 15 Jan 2024 10:57:31 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
Message-ID: <20240115175731.GB156208@fedora-laptop>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <gmunf5rk52zg47zabt6i6635r7ddspvujq5bu2kirffwozjfm3@wj3ehlzwzuwc>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gmunf5rk52zg47zabt6i6635r7ddspvujq5bu2kirffwozjfm3@wj3ehlzwzuwc>

On Mon, Jan 15, 2024 at 12:48:28PM -0500, Kent Overstreet wrote:
> We've got a new CI failure; it looks like perhaps the MSRV environment
> variable isn't being set correctly in the test environment. Can you take
> a look?
> 
> https://github.com/koverstreet/bcachefs-tools/actions/runs/7532280737/job/20502558560

Sure, I'll take a look.

- Thomas Bertschinger
