Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB8D20DEA
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 18:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726601; cv=none; b=ohHn7Up6EXqcAg5gGn8Gh57i2tc9bOMAbe+J/jjqg2uvtdB43twT4HXLOjRief8csBV0Ymw4j1wl7/XCTBHK6Vvd09/ICRV+OY3gQUUAjSOp/M9nFkFl/Jo1LxMRdSg5uzCDgb+HaMtCBbNDCcPocm2SuwBG4D9GasZIkIlddUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726601; c=relaxed/simple;
	bh=0cKd4AT4fjEWTNX0Jhv5pqDUl2STqJJegG1/RyRkH5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+5pYaALR7OCMV5A9e7ZgD5q7fc6Fin6VuWCnKyKe4oFnAP+PFPNrSu4fFldB3LGj3iq11OT6/31U9iaLkDCjujNI+ysHTJirO+f75qR7496Z/DCGM0GRjCDxyyXCu/AiQSuvO0uP99mviX3YTioMfLhyi5A4CT9mHxjn5INYJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HbcGnm3v; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HbcGnm3v"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40fb020de65so1061635e9.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 10:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706726597; x=1707331397; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Krf7Z+xSZ+SnL30qhzhbVXf4zGbsu4d5eClv7fEOjKk=;
        b=HbcGnm3v0hp7inEoqcYwAu1gUCgVqfCPgIi8xSAq6zp+MENR53Pqp5+me91XooawJk
         UiyuicOe9+ldLhExr9LIAb/SX7jAFOBWDutAcnRgw1YTpvBYkUW5vp/KRdmZ0rFjxp36
         RgQHXPeXz0mAnIPnc3tQjI4ywtN8uc2UcXNzstpiYxjYzYZjdlVTt4dEdjS43FzGyt0e
         JIICDFlmvIEIU0+UNEmrSQgGC5eJAO2R/y+5v0FZajzKbciCT4G7X5eNX1YpIFLyH1sm
         S2CkPlUofVgiOzq6lu4DukWTI3z6vdKYHOzuJ9ZVi/Pl05FB3BVuJFZmdDMr61N7VCng
         +ahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726597; x=1707331397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Krf7Z+xSZ+SnL30qhzhbVXf4zGbsu4d5eClv7fEOjKk=;
        b=ZGNlo43y4LUDD3xJ42Cc5BvZVVRVNKBEG/qRVRqSArVikADV+EgUVV86gmONMYm676
         2ujXLP/0MN8xpYS8z6+ZpuUwuq7QeOhzxX+t31jq3Gn1Vt3ShCBjbmchSn42a+05QZal
         4ZAdiLky7wZfdNXe7/szonwvSsUIgbMUhCDsN9CxSk+OKXfx5XcjJoENXyogvXW3No/3
         FTzQpCrDV8L7ml5WMx4S1ZM8WUCyg+KdermugolMvvF+WSvXskT3AUz1eeAXC6DPALrR
         g+s+XnZM+uR+OvBA6Oaapf+fEkR2SkqbV6TtZC7d7BExBXjTDikaJkwqawCs+gHRiAfk
         Oskg==
X-Gm-Message-State: AOJu0Yw72B7JlAqNfKOOTSrV0unQac3S1WlBXfn6rRlg2owr0u5wu/YB
	hCJihFMKDHOqayxXXAK7Mi7AYLEKMKIEQjXk1fy39+Mup6ioInQRFITJnaKmFwQ=
X-Google-Smtp-Source: AGHT+IFc0Yw+TPzkftPyQMjSzGGuEqiIdByAU+adAtUokAmw4SYqMxWGUb6XCHOtV/9Zeva9T10POg==
X-Received: by 2002:a05:600c:4ed3:b0:40e:6d25:d0e2 with SMTP id g19-20020a05600c4ed300b0040e6d25d0e2mr2029418wmq.27.1706726597595;
        Wed, 31 Jan 2024 10:43:17 -0800 (PST)
Received: from localhost ([102.140.226.10])
        by smtp.gmail.com with ESMTPSA id j13-20020a05600c190d00b0040e88d1422esm2349874wmq.31.2024.01.31.10.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 10:43:17 -0800 (PST)
Date: Wed, 31 Jan 2024 21:43:14 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
 <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>

On Wed, Jan 31, 2024 at 10:59:13AM -0500, Kent Overstreet wrote:
> On Wed, Jan 31, 2024 at 06:24:16PM +0300, Dan Carpenter wrote:
> > On Wed, Jan 31, 2024 at 10:10:26AM -0500, Kent Overstreet wrote:
> > > On Wed, Jan 31, 2024 at 05:52:11PM +0300, Dan Carpenter wrote:
> > > > Hello Kent Overstreet,
> > > > 
> > > > The patch 1c6fdbd8f246: "bcachefs: Initial commit" from Mar 16, 2017
> > > > (linux-next), leads to the following Smatch static checker warning:
> > > > 
> > > > fs/bcachefs/btree_io.c:1672 bch2_btree_node_read() potential NULL container_of 'bio'
> > > > fs/bcachefs/btree_io.c:2165 __bch2_btree_node_write() potential NULL container_of 'bio_alloc_bioset()'
> > > > fs/bcachefs/ec.c:734 ec_block_io() potential NULL container_of 'bio_alloc_bioset()'
> > > > fs/bcachefs/fs-io-buffered.c:489 bch2_writepage_io_alloc() potential NULL container_of 'bio_alloc_bioset()'
> > > > fs/bcachefs/fs-io.c:81 bch2_inode_flush_nocow_writes_async() potential NULL container_of 'bio_alloc_bioset()'
> > > > fs/bcachefs/io_write.c:407 bch2_submit_wbio_replicas() potential NULL container_of 'bio_alloc_clone()'
> > > > fs/bcachefs/fs-io-direct.c:622 bch2_direct_write() potential NULL container_of 'bio'
> > > 
> > > bio_alloc_bioset() is mempool backed and can't return NULL
> > 
> > There are three return NULL statements in bio_alloc_bioset() and the
> > comments say it returns NULL on failure...  But it's simple enough for
> > to delete these from the Smatch cross function DB.
> 
> So it doesn't seem like you're doing an critical analysis on individual
> bugs, so perhaps these shouldn't be on the mailing list.
> 
> If it's just going to be bot generated and not human generated, perhaps
> this belongs in a dashboard instead of taking up space in a
> communications channel intended for humans.

Come on Kent, don't pretend like I haven't pointed out over a dozen
bcachefs bugs since it was merged...  I'm just saying the comments
weren't obvious here.

regards,
dan carpenter
