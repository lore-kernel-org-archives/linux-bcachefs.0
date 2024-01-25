Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F276B6E2BD
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Jan 2024 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706193495; cv=none; b=H77DogYfg5w8l0URO39K2nO84OEgRE37uS5e0y6XtL3WVbT8NSK8HystSG7jqfMeWj0IJJAj0Eob+2YMTJu4wBnURiQ7piXe1oBn7nGUriKoCI6IwhdGdQX1ZLSmkh/LjmxQPScagoFLIYlOoNuB94+EGupMmXzywkH7KLwAo80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706193495; c=relaxed/simple;
	bh=4CPin/+3BMbO2I4r4LkYmRAf7JTvFhCzfcCqTvJ/+rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujxqC+EE/N9YNBr1Vyn+dvF5KYARdXgbEaCD7cI02fe5/EGnk9d8kySlaOY7cZQ8D4RDUIsQE7lNZodvz41t/EgG0YOiLv3UqCpF5OMa08UwAS900klZZvT/cCz8IvdRPEJfH6fbw45Vrr+2aTCryMsB+I0jUg+zP3RZz7Pb7wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ufqw8+sT; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ufqw8+sT"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3394b892691so485145f8f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 25 Jan 2024 06:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706193492; x=1706798292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UL67qRzeGSzlVbCK/wezSUaCZaxQ3JKGxyhMYaK5cCw=;
        b=ufqw8+sTCAgCoX+WJAGdI3TWUsDVP8utnR0mRMleHy5Zsa5aekh/Spswz13k0PD15v
         CT+oITusEh7mvoSR0XXJ8hKMcfaOvX5FhQjRPXtCKzatC4dPMV+tixtFygM48GpXk4KE
         dE1ppwrei5QGuDTJPRJJWyhnWBBBUO6sX+6aEmFWJMCOmw0FQuEAFl5AuwV+StgaxKXu
         iQbsdD4tNQM6IV6GoOpx8zb99tyRwO/qLZtT/22kyaUwqe12M4pv++6LQndXuJevZTm2
         QKSYfR2lNWXIgVMWnwajz3eKfguBBVESGQ4QfyAtlGtdD7NYME4AkLJ4Vm+2hxbxV2an
         eOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706193492; x=1706798292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UL67qRzeGSzlVbCK/wezSUaCZaxQ3JKGxyhMYaK5cCw=;
        b=NHDBfGu5+UPy8LEPr8WOjvj+vw6fZ3j+Fp6c9gmI1pY0myWiv4htup/cKcaZ6UbF4y
         DuY8trq2Zf+qjCQmmi3p9tFmwe8SbgbT45MbI+z6mtzdsMvWi5VtKkb/KemD9LIWmS5q
         XWfruGM4dKnVAvQMHwggPbl+SJaknCkRZ+UOi/5J1rXoTuS8Fm4Bsex/bosq1drnVIP9
         XqSokrOBbWzvuFMdoGxDbcD+oPZdFSznlUVr2QchowJUHH2ej/HelIyobU/ijQZwWwTh
         mxOST8LLunWCujcH2zwrcavaUvV7UBPj278NtTm2fKqFvOq95DkOEncWUPJxFod/YE9f
         CUaQ==
X-Gm-Message-State: AOJu0YzIjXBS6uD7zqdEt6q86IYGbF55SdyzASn6YHip55WRob4wj8i/
	WK4YXbcVoOMQ4jSmKFL7m60jn116+rI839IQ85guDUzl2JuXuKpuVTb/sOTYzP4=
X-Google-Smtp-Source: AGHT+IEIVs8na4MnxOelIoYZBmeI5u1yKi7k74NvfaRRHdQhBZHIdnFxAGuFHncR28DvQ3bjBkQ/XQ==
X-Received: by 2002:adf:b35c:0:b0:337:d647:533e with SMTP id k28-20020adfb35c000000b00337d647533emr639839wrd.52.1706193492060;
        Thu, 25 Jan 2024 06:38:12 -0800 (PST)
Received: from localhost ([102.140.209.237])
        by smtp.gmail.com with ESMTPSA id t8-20020adff048000000b003366c058509sm13003630wro.23.2024.01.25.06.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 06:38:11 -0800 (PST)
Date: Thu, 25 Jan 2024 17:38:08 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: kent.overstreet@gmail.com
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checking in
 __bch2_btree_root_alloc()
Message-ID: <48963b33-f679-410f-92ff-bfa55d47518e@moroto.mountain>
References: <14684abe-5652-459d-aae5-278da8cb7b36@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14684abe-5652-459d-aae5-278da8cb7b36@moroto.mountain>

On Thu, Oct 12, 2023 at 12:43:46PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch e0750d947352: "bcachefs: Initial commit" from Mar 16, 2017
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	fs/bcachefs/btree_update_interior.c:2336 __bch2_btree_root_alloc()
> 	error: 'b' dereferencing possible ERR_PTR()
> 
> fs/bcachefs/btree_update_interior.c
>     2319 static int __bch2_btree_root_alloc(struct btree_trans *trans, enum btree_id id)
>     2320 {
>     2321         struct bch_fs *c = trans->c;
>     2322         struct closure cl;
>     2323         struct btree *b;
>     2324         int ret;
>     2325 
>     2326         closure_init_stack(&cl);
>     2327 
>     2328         do {
>     2329                 ret = bch2_btree_cache_cannibalize_lock(c, &cl);
>     2330                 closure_sync(&cl);
>     2331         } while (ret);
>     2332 
>     2333         b = bch2_btree_node_mem_alloc(trans, false);
> 
> Smatch complains that bch2_btree_node_mem_alloc() can fail
> 
>     2334         bch2_btree_cache_cannibalize_unlock(c);
>     2335 
> --> 2336         set_btree_node_fake(b);
>                                      ^
> Leading to a crash.

Smatch still complains about this in linux-next.

regards,
dan carpenter


