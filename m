Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531DA84A57
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 15:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706714664; cv=none; b=f3gOXbQEyju5+weLxY4fNNHztutiiXJPZAxGBquOfq3p8EikfO+0qlDyUUnptGC/DQ+lNR6zF0lw/iK+sYtu6T+x1puH3CtB8RKjot3ZMfKMdqvHyffgaFHlv0lqcLzOyD2OsBAXXZK20xeUGds+qKS6gAMax5Kt6v5Cht5UXCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706714664; c=relaxed/simple;
	bh=ZKHwksx4EdTqFKePye7mFO8W8q5LEC6I64LQ1nMwaHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aec+2+GrRZCxAuJQWF8zE9+dlXxOc8UwhPXdkMZRpCb5H4i4/ni82O4nQTWQVwceDOcLUG2zokJQwF/7J1tbQrU9C5lweW71Y8nmUfcDmEHf3C2+yTZnfm77OtIqClmzj65WlY5WA0pg4o0OHY15RmfwpBdr/JsrqfJwRy86qSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n8/GyPG7; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n8/GyPG7"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40e72a567eeso69103365e9.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 07:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706714660; x=1707319460; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xmiBPdnOxXKRUxspDh+HrTiPOmfgjlHjCvJul99lLNQ=;
        b=n8/GyPG7G9Lc27D6IVC7I+1kw/AI28l1X+SGSe4euvos1bjdjgoELAGsmXK6TIfN2G
         N8/Yebfyorxjm6eFceFz3JxFCezQGHrtDVugKebpRcb3T/EImrQ2hivTkee4McXJZw13
         iyRQJMBevP53Jz0lSbZgBGhloLDGuaJw3nK9eYXs9ciHDStv8Qrk3UY2/jDEG0VDjLYI
         llIwUt7VR2xZXeC7VsbZv5oqEt1YLw4kbE+C5M2o9kqyQ/ZpyyZtdLYyw6C0W6u0o8nI
         h+gV5NXZ3XCM7fkBFeMO6tR4oxBR4slIUKt2Wd0cq8CXiWAUN+eWdMRXMPqFKfj4GG4D
         plGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706714660; x=1707319460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmiBPdnOxXKRUxspDh+HrTiPOmfgjlHjCvJul99lLNQ=;
        b=VqaenAMhR6IBpms4quSgFKLlhqGkHf5+z4cvTCMwmQU7WAT9JaTMNHIWGMqvvKkg5A
         0QZ2PS8tw2971+ThqyQL6/251c3y9fbyVoRYPyvlU9MaDOFu9W+RvHjUzOUCMgTJWFk8
         txgcy96mpviCgE/EMX5LZRXAHKziPhqkl1fk6msobi0Z2lqJpTbpFk+somMNxdm4UBfx
         JDPgG02+bI2wR1IpC9KSsExCbB4U2iDr6N/k/ipYwb7bTcUc1Pv21PO7ZjjUyZUQxsLg
         GW9p4ibpQ6ZrS97BD8ccFVm1ji+OSmHVVEcvlkjhZZS6GyVbfBvPt04+nTcIPbFYCJyV
         JPzg==
X-Gm-Message-State: AOJu0Ywm3qBZMZQBaoUzkFwJLVWdj+44h5r1VIh1M04fUCOxKEGC8y5W
	g3PxkTSAcA1rSuxJXrxuXgjLkkV6HGOSzLAfsaAhnDOJU9ClXVMZFk8w826cZ20=
X-Google-Smtp-Source: AGHT+IFsLdSIPlqFodWFa+EoLyMmT8seGYT9TzR5NXUbNu6BJmTvzCIFlY27XvScXa6+CX0zgEaO3Q==
X-Received: by 2002:a05:600c:5013:b0:40e:4897:c772 with SMTP id n19-20020a05600c501300b0040e4897c772mr1974926wmr.34.1706714660545;
        Wed, 31 Jan 2024 07:24:20 -0800 (PST)
Received: from localhost ([102.140.226.10])
        by smtp.gmail.com with ESMTPSA id e1-20020a05600c4e4100b0040ee4f38968sm1896210wmq.2.2024.01.31.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 07:24:20 -0800 (PST)
Date: Wed, 31 Jan 2024 18:24:16 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>

On Wed, Jan 31, 2024 at 10:10:26AM -0500, Kent Overstreet wrote:
> On Wed, Jan 31, 2024 at 05:52:11PM +0300, Dan Carpenter wrote:
> > Hello Kent Overstreet,
> > 
> > The patch 1c6fdbd8f246: "bcachefs: Initial commit" from Mar 16, 2017
> > (linux-next), leads to the following Smatch static checker warning:
> > 
> > fs/bcachefs/btree_io.c:1672 bch2_btree_node_read() potential NULL container_of 'bio'
> > fs/bcachefs/btree_io.c:2165 __bch2_btree_node_write() potential NULL container_of 'bio_alloc_bioset()'
> > fs/bcachefs/ec.c:734 ec_block_io() potential NULL container_of 'bio_alloc_bioset()'
> > fs/bcachefs/fs-io-buffered.c:489 bch2_writepage_io_alloc() potential NULL container_of 'bio_alloc_bioset()'
> > fs/bcachefs/fs-io.c:81 bch2_inode_flush_nocow_writes_async() potential NULL container_of 'bio_alloc_bioset()'
> > fs/bcachefs/io_write.c:407 bch2_submit_wbio_replicas() potential NULL container_of 'bio_alloc_clone()'
> > fs/bcachefs/fs-io-direct.c:622 bch2_direct_write() potential NULL container_of 'bio'
> 
> bio_alloc_bioset() is mempool backed and can't return NULL

There are three return NULL statements in bio_alloc_bioset() and the
comments say it returns NULL on failure...  But it's simple enough for
to delete these from the Smatch cross function DB.

regards,
dan carpenter

--- a/smatch_data/db/kernel.delete.return_states
+++ b/smatch_data/db/kernel.delete.return_states
@@ -12,3 +12,4 @@ scmi_raw_message_dequeue 0
 __hci_cmd_sync_sk 0
 regmap_read (-22)
 regmap_read (-4095)-(-1)
+bio_alloc_bioset 0
