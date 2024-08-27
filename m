Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA7819EEB4
	for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 10:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724756043; cv=none; b=bPFhlKvGwABng2ZyC7ANlG6H2xKdnTK733Sp4NvF4uEVnwbAil5ovRrJhF+LnvLv7CG7kpi1DESV5uClJ/aynLK9BgV8QDUKr8DHxb7amqZFcZJcCW+XKyxRsNzvZC7qdU8F1PvoqybUV0xeHLXbImcj1vAjhoNG/XWSgta6nrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724756043; c=relaxed/simple;
	bh=OIj58p9z7PV/B67T6gypj3fNfOS7T78tyJTwBuw4LCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijEp/vx9Kng/D9WIxpzE6yFoEXOEmQotV/YonOYotfZBBJVs5XrE5vDGd/+IhOJUQETgTtMR157PdF3vUydvBytUMOZr8VQfT+b4GgphZz3Gs3DKKZeOBtmsB2c6+/cK9oXHsZSthfiEPAPd3oZXjrhF5239drW5OuZx6JbAnL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BBbMK35P; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BBbMK35P"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a869332c2c2so800704566b.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 03:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724756040; x=1725360840; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e2+li/AcO6Ae1QDTZoYlXn07+RgNIMHrKujTKXnZVo0=;
        b=BBbMK35PkxYByELaBa1CGWfW9sUlRE+9B/LnbIXN5AWLvxMQK3BPMntBo/VmTs6oAH
         gxARpSAkgitHumIzpyyV+CyGwoqj7/GUj2UZZ+xYIAJd3MpLfzkBEWDofKBM/MQASu1M
         0/ngdfKRABPBHK2PSF3rcS26Wx/SrAKSJXfg4C3ne27pYq5NG3/lfE7oR1Js3//bw+60
         OKSOFAVcWhF7gIMKySc2rSwI4VTA6cEJAfBDxvH82U2FFUKUirUMSzj7Db2cfyweXy4Y
         BdEsabvVW3cINJr7TBmikcbY1j0yzNyc7iZzNpC9a1m1oolv9kDUSM2uAn6xyCUv5wBZ
         uy9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724756040; x=1725360840;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2+li/AcO6Ae1QDTZoYlXn07+RgNIMHrKujTKXnZVo0=;
        b=WZRzdFauVYLFPXOWRLueKM7uK98S6JsWnTg0WBU2W18m3YedOBnjc2vwL35YhWoJlD
         D019QWTQVznwZrhWLdPHe9HX8MrlDcUmR/IEnOFjbEHcbCQnO+4AHSmFkxrAr2AtZ46B
         gLtoRDkIEXlv/ZxyQporXkpBfTfKySuWiJjJT1qZ6rGgQ8IB2EQSrDfh+HWHiHREW5wl
         FTOa5UV/Sm2StOmb5On0Rudaq7yiIQq8yLbW2favUWfKS4xWZKm6ZDNMuwwbQyPzn1bi
         3ZVuCZdx55HhIsgtp6dWcdBQkZcarBMOwkIm9yVBaw0NmjOvwG8Ur2fqAyK5MDlr4B1I
         o2zA==
X-Forwarded-Encrypted: i=1; AJvYcCUyhHWAW9raFizXu20tIxAcezzd45IlmQ3TTtQBx74dKOQY6OcMdJlmMdZ+mfNm7xFlQMRaEjp925oTARzKqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YybuN1KZFY4tuv1OU+7leVDuLV6WoWlEpRijqpUHMl5cGu0MPqu
	ylbCNNMEWIc7o2yg+8lcSfg6nE9RC7m5w0J9MbAhzX3WBCTcVqJ1NGfxyxmjNRs=
X-Google-Smtp-Source: AGHT+IEjFrTYI+AqR+e7VmGfKsN/nVI/pn6+NZveY9Op2DOsbXHXpZ55OtFZDF3A7ozw2wnssRp8JA==
X-Received: by 2002:a17:907:94d0:b0:a6e:f869:d718 with SMTP id a640c23a62f3a-a86e29be930mr257003266b.21.1724756039983;
        Tue, 27 Aug 2024 03:53:59 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86e58a57f1sm93454166b.187.2024.08.27.03.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 03:53:59 -0700 (PDT)
Date: Tue, 27 Aug 2024 13:53:55 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs changes for 6.11, v2
Message-ID: <d0da8ba5-e73e-454a-bbd7-a4e11886ea8b@stanley.mountain>
References: <73rweeabpoypzqwyxa7hld7tnkskkaotuo3jjfxnpgn6gg47ly@admkywnz4fsp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73rweeabpoypzqwyxa7hld7tnkskkaotuo3jjfxnpgn6gg47ly@admkywnz4fsp>

On Thu, Jul 19, 2024 at 06:36:50PM -0400, Kent Overstreet wrote:
>       bcachefs: Unlock trans when waiting for user input in fsck

Hello Kent Overstreet,

ommit 889fb3dc5d6f ("bcachefs: Unlock trans when waiting for user
input in fsck") from May 29, 2024 (linux-next), leads to the
following (UNPUBLISHED) Smatch static checker warning:

fs/bcachefs/error.c:129 bch2_fsck_ask_yn() error: double unlocked 'trans' (orig line 113)

fs/bcachefs/error.c
   102  static enum ask_yn bch2_fsck_ask_yn(struct bch_fs *c, struct btree_trans *trans)
   103  {
   104          struct stdio_redirect *stdio = c->stdio;
   105  
   106          if (c->stdio_filter && c->stdio_filter != current)
   107                  stdio = NULL;
   108  
   109          if (!stdio)
   110                  return YN_NO;
   111  
   112          if (trans)
   113                  bch2_trans_unlock(trans);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^
Unlock

   114  
   115          unsigned long unlock_long_at = trans ? jiffies + HZ * 2 : 0;
   116          darray_char line = {};
   117          int ret;
   118  
   119          do {
   120                  unsigned long t;
   121                  bch2_print(c, " (y,n, or Y,N for all errors of this type) ");
   122  rewait:
   123                  t = unlock_long_at
   124                          ? max_t(long, unlock_long_at - jiffies, 0)
   125                          : MAX_SCHEDULE_TIMEOUT;
   126  
   127                  int r = bch2_stdio_redirect_readline_timeout(stdio, &line, t);
   128                  if (r == -ETIME) {
   129                          bch2_trans_unlock_long(trans);
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Double unlock

   130                          unlock_long_at = 0;
   131                          goto rewait;
   132                  }
   133  
   134                  if (r < 0) {
   135                          ret = YN_NO;
   136                          break;
   137                  }
   138  
   139                  darray_last(line) = '\0';
   140          } while ((ret = parse_yn_response(line.data)) < 0);
   141  
   142          darray_exit(&line);
   143          return ret;
   144  }

regards,
dan carpenter
