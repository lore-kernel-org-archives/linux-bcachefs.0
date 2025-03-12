Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F290620C472
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Mar 2025 08:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741768378; cv=none; b=k2v6Vec9ZI3iKAFaHusiTV7LaXvcMSyD1BW5Xfh+sGlwmMteEfRllpBfndby35Iu0r90D55uiS4kIY7tyTmNEnLZmqBAWaaeL6iVdLbiFDILO1ljwQFjZ6ibl0eF9Phh9o7YncdSZNsVvUYjJIQdfran4O6+QcKR0jMYKp60DT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741768378; c=relaxed/simple;
	bh=zNJtVD3+Y6u2bF4Bk5i/C+GkgJh/ZgLQarm3MvGOm9E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TfS5e1y4JoXcIP+fR++8g1SsA0Je/K03zQs22v/Qnd/48H7lY1309pTu4zIxChN8Pua5aSDQXHA7ONkmVcxmTK9YPHI/aBhljFZKTaCjXnTPyOU96q6tPVOP8TupuNxwPHWiJy9FAgw0I3/1jqcUXcQ6YgtJaOKulitq8dTF84c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gZstWXUK; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gZstWXUK"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-388cae9eb9fso3095425f8f.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Mar 2025 01:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741768375; x=1742373175; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bPfEmD0cKMr9Kzpzes0hfJXBAPapx/ziI/TSz7x+lUc=;
        b=gZstWXUKGgYAL6Qo4ePZPuGOaHG2XTW9IVZWA2XlOOpZhN32nC4jhKqaSPPcc4p2Oq
         nfx6UrSsGkSCcN5tJHLKk4jjrnLx5eDKT+0p0FYzloexvQzy9To3RQtR0yoT9yTDa3vt
         /gBC5ZTMNOneb4G8vHAJJ4yg4dw3LA3WD9g8xo6FLAxk3S4t2SMkEr2zh44KhG/y0WQq
         CgXQhBAV5mKPCcVmdYZk1EwoAMQE5iiYXJBvDtfoX2HpjCvxLeRWXY0RX/hBS/iQII32
         b1ODYn+smZzIYDd7RdXFrQg7G654v2fkouobjhd2eM+9ncbTbNioAoKlkdSq3uraMoVj
         0DhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741768375; x=1742373175;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bPfEmD0cKMr9Kzpzes0hfJXBAPapx/ziI/TSz7x+lUc=;
        b=gRd6xC5hlthMzVxuDLQ2i7X3npfk/RodPzdNSmCCSSbzsrVglgXxfWUGagg4ANJYda
         A/i0bUwrsGez4w6+0CMtGUQQBfj8IqFxfAdNMULtke54EqfbF6K6sFwqr46ZEEPVhj6l
         4Z/X3/dBwEJC6z32QDi6mtuMFSOFFD0+CWfNyY0EoFBGBtbmSPxuJlhmZ3Yr+UxqhVLz
         5g8UyVAe69JgyiThuS6pcmA2XTA/eqEz9Ui+0uoYimMlzzUegGMarDJPGQwDuoHt1Zuk
         SRYP6Nlbs1J5F5PokyBsCtsC8qTNF146nHtUybsjtvz3SyZHxMhsuB0vSdJTgyEXFuXv
         Dm1w==
X-Gm-Message-State: AOJu0Ywa8GaeLMF3mlBO7W0lokv9/SJbN9hVyu5lqTAeES2hzFkWmT+W
	iYPdeD5fV0YD3kTMuKWYiU2Y8prn477PICXMsHlkf0FZXe43j4dHOVA+BxGIAk1mcA1oh8IjFgG
	f
X-Gm-Gg: ASbGncsz0q0pQil5FQmDHe5k6p3JO4JMtRrT8y1aoI2H1Bv7Z2XtpUn1CqtdhdbKdt4
	yShRo1HCL3gmC2nQafFdi7J1j1ct6kQGDMaTAEghLNB19l2tGqna79ti8V2jR5usicHMXitjBlv
	PG7AjU7Qv/XeQoHPcdztoCqosSWdxkBs9NAaY70r3C6PKFSSMV9crKIZLLQm+ADQznRgZfaszfY
	GEhEjMLK42iCQj2blnT+bHms8B/jiwf0sJiTzoO+IOM/Hn0oxxyjcl4SgP6oaCE5bjjswk28swR
	3JQet1PczNy8laJHeZ50v9lWPBCI+MPDvAIeWYGplJOJ+FLJOQ==
X-Google-Smtp-Source: AGHT+IGi3eZ0ESgnb/92HfNrMKlw2SZzMydr2edOFc91a6Db78IDbbE7pQ1nP4q1z36ZxBdmAd1SOw==
X-Received: by 2002:a05:6000:1fa9:b0:390:f0ff:2c1c with SMTP id ffacd0b85a97d-39132d4808cmr18553158f8f.18.1741768375305;
        Wed, 12 Mar 2025 01:32:55 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3912bfb799fsm20322523f8f.2.2025.03.12.01.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 01:32:54 -0700 (PDT)
Date: Wed, 12 Mar 2025 11:32:51 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: Improve locking in
 __bch2_set_nr_journal_buckets()
Message-ID: <e792b565-4017-4322-b33b-47f9ff0b77fe@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kent Overstreet,

This is a semi-automatic email about new static checker warnings.

Commit 76966dbfa9eb ("bcachefs: Improve locking in
__bch2_set_nr_journal_buckets()") from Feb 11, 2023, leads to the
following Smatch complaint:

fs/bcachefs/journal.c:1184 bch2_set_nr_journal_buckets_iter() error: we previously assumed 'c' could be null (see line 1153)
fs/bcachefs/journal.c:1187 bch2_set_nr_journal_buckets_iter() warn: variable dereferenced before check 'c' (see line 1184)

fs/bcachefs/journal.c
  1183	
  1184		bch2_write_super(c);
                                 ^
Unchecked dereference

  1185	
  1186		/* Commit: */
  1187		if (c)
                    ^
Checked too late

  1188			spin_lock(&c->journal.lock);
  1189	

regards,
dan carpenter
