Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900BF79F0
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 05:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708579506; cv=none; b=ew4Xigy9aw8mxxgMBCTYZVKZpgGdwnp1sfd3MXvyJ0Qs9JgH+UG6ZOSSA3YMafupS/PpYoSlhzEumPyxLmqfKA3di7OVSUV3Lz3v5fjhmh0cvGxGwJ2eb6jsxy4uwMKQ5udROMbMykDXJZtZog4Nty/u4K9fleLXRHVlRJ4ddj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708579506; c=relaxed/simple;
	bh=8H/BzytqOZYzFjZacY932uXfieYnQyStCWl2l/du+ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/FpctOqniGmRX27VnARkIvjWu+fPb0MJH3bg6zM+5PcrlQ6jYCdTogj1/oDyA+uHJ3veC5mONUu0V067OMr8xZH6YTzxFpGoMysYQ+1PcNDfOrd7g3Dc10A1oCuGmBi181KBwDLm8VRtwZlfI6CN1iPyaSfWCUMbsk9eMNUQNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ix51u0ti; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ix51u0ti"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-33d90dfe73cso82487f8f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 21:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708579503; x=1709184303; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8H/BzytqOZYzFjZacY932uXfieYnQyStCWl2l/du+ws=;
        b=ix51u0tiPc2BdlkZS3k/4vhnj5pk1TgWrLfxU9VZcC9OMdkLtAL1zTmT9mEmwT44/a
         uVVeCSQyE4g+3D08w1fV5LK+6r/T3hpZIEr7ae0gU4YtF0Od1LuevAeYT2FQYSA9yNFO
         tFVW+iHZ3P/oH2vwH7EoGWByWet7QGyalF7baflv09xeIRgavmq5SCXqD5GcWOR87BR0
         oYE708MaWijQ7ZlYAfPHiCoU9OKKsPPfBB+h3fM8BteFuPj4PqEYo/aC9IOCUU/zE9FR
         Mbf2OrBj2UTawxgAdxfvZTcuspg7td3MccE2vyR00lyw2yUut6VupJGX49hlwHQQpRft
         tbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708579503; x=1709184303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8H/BzytqOZYzFjZacY932uXfieYnQyStCWl2l/du+ws=;
        b=WCtPQx7pPVFZ+j6hoPvCrxqEx7wkkLO26VdIzJWAIv8geid1kaSqvJlGigVbWkjO6D
         WeD9Mqr59wZAXHSK9/QlNoqaxBQ/g8csp5RU0hTdhBhl1uIZezbtpNREG38R6dBsBXbP
         QTLWV7igao67v+lK3iIy6f4kLxeS0luKQA47cDST2q7YAR+4fMfW4jtksEbmXIMvWvFL
         JBmKnIpoxmwAio72Y8AQwQDHfc40jReB2g6bVaZfjv2iUz+5R+XBcVsYEzWSMC6X+1CG
         HksRZX6Wx3RiKvTSgkiOp294MJJ6ToWHvOXJTRoujaGVZZwC7WISzpokB+2albYGN2rX
         Y1MA==
X-Forwarded-Encrypted: i=1; AJvYcCXELagIvLr8PHFfxbnXB3ghJ6UpGVyqTa8FyQLfMRHV9deELvO6IELsVBQECkxpyze+x7kQHXszQBxxvAba+MncfcoBA90qjpspHnkOaxw=
X-Gm-Message-State: AOJu0YzGa6Y37ySZSarNjjktU+7gw+f+ts9Z2zHW7RC0saZCu2EUGviG
	QiLapcRascht9xHTku5y8VtJqnafZSnS7nHl549NA91lU25oovV0sX5N1Xj/W0k=
X-Google-Smtp-Source: AGHT+IGccZ0j73/5DrOmMr+HWme+77iCv5MXgbQTR75Cls7ZJMbT2w/CLOu9Xq8tSwrznHtU3sy6jg==
X-Received: by 2002:a5d:4d8e:0:b0:33d:6fe1:8dc2 with SMTP id b14-20020a5d4d8e000000b0033d6fe18dc2mr1057619wru.3.1708579502807;
        Wed, 21 Feb 2024 21:25:02 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id e2-20020a056000120200b0033cf80ad6f5sm18922729wrx.60.2024.02.21.21.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 21:25:02 -0800 (PST)
Date: Thu, 22 Feb 2024 08:24:58 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Colin King (gmail)" <colin.i.king@gmail.com>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] bcachefs: remove redundant assignment to variable
 ret
Message-ID: <bc2cef70-6adf-48cb-814c-a1087939ec17@moroto.mountain>
References: <20240221115203.3413554-1-colin.i.king@gmail.com>
 <3qaoftjgf7p2ugutl524b3yin7pqpjrkftjx3frunhduf3so66@tjhcdoq6unk3>
 <cfa4cd82-67e9-4483-9c35-a425859f4a21@gmail.com>
 <27hacgxfzyeatjx27nb4k5rb5cajt5yw4c2papfr4h64urb7qx@teo2ha6msqnl>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27hacgxfzyeatjx27nb4k5rb5cajt5yw4c2papfr4h64urb7qx@teo2ha6msqnl>

To be honest, the point of explaining how to run Smatch was really to
let you know that you're now on your own.

regards,
dan carpenter

