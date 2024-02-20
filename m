Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7198A664A5
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 Feb 2024 11:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708429183; cv=none; b=kRhWTvDL8cDR/A/h4lvSR+wjyMu9bKjfcc5IvAPX4ywVdtWiLyx8ejf8o66GUEWgkaYzOZNWt0lD769iNbko7T3R5jo7AvKjd04C3NcTo3p/zHnsz66GuUsFK8O9gOWoUK9y3HN87ytRQ1bmyUOGH+KynyUF9uqFcx5q9CylsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708429183; c=relaxed/simple;
	bh=JVDIMK41jc3pNepHU2vav8DGy5t+qeji6a6keUr2iCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r87E7qug5yPXXerG9ecUWYbg7ErG5wqRRy4Krt6trZk3Cua8h1I+Wz/2Km8ar58sp56ivy5BZsYGXvKMRZOHgFry1BbL8/5oRwewXFerLPHr4/bZbIGiyTkXIqY0Eo5/5yqB5wl1vCsDlD5rmYIYSXQVLVVul1KcRSGHESYRGnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pdsFV8hc; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pdsFV8hc"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a3d484a58f6so703052866b.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 20 Feb 2024 03:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708429180; x=1709033980; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y6AgR+qKzMXWThuThucHgTFtBAabfN0cdFISXI5ZE9A=;
        b=pdsFV8hc7nLjUCSMfjpOUqHgOxk3AY2hxRYpN3JddCebXZHGEQDH7ttpRfTxrs/61J
         vTqLybsDyENKo62rkNgXM0HzW3yV5mf4IZc7tzQ0bmtwKD72Ec5Kz1E5DZljizR4w5u0
         UykxbRSq0U+Dabf6TG/E7hwueLEZAVQecxpFFR97MgBFqyP1EOhS9XRVjFZ2JcbARI7f
         YxTfdrevwfLLROc7hc8vaj0qIK5c2RfKuHBRkfj7xbPPtkH0vUWJbEIvP+Jt0V8hh1oP
         15EwVq6N14x9OJcPDqUdUn9J/jstbOlzQYsxOiHcMLrUc2lSq1lurQWcJiz3D+oZxLS7
         wBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708429180; x=1709033980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6AgR+qKzMXWThuThucHgTFtBAabfN0cdFISXI5ZE9A=;
        b=XyStHy92hbo9Ya5YZ+6HHt3z0wk6efW4k1/MfJzIJ8z6D/ng6FvxVFarYqA2PP93vV
         iHQCGTQgMVxixaplOD7JOtU2QWqLxxRrxvga0A0Zkhgn3m8DlRbRJi0JMccrwyek+MQ/
         n4hzeATtM5V4CiUfJ8TgkqRgF/EeSiSC6NMOqmf3AhTeIoS34CoBFKNR9CTDyA/wUPfy
         3JEK5qBc61mj2eR/pqz0HK8Dl36SvIE6Z7JOiOHgCceTeU7LL1pdFZ3A/O35WvZyXlbt
         WaEhJ2S5KukrIHUH6UTSo72NAdAapAYFtiB22Y/K24XnBQxP1C/l4qCunJBXkkjWEaId
         NDcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx6m5xTddKt6abu1hvcaQ5FpfhGdqui/r5ejsJ8/8w7GYuFf3r7KHPO4p7E2Cnx3tU430tADPq95CrpB7toBr4BVjp/Lg47XlIRzpx1vw=
X-Gm-Message-State: AOJu0Yw6wW/ATktLQ/Kxoi510N92sVg96egWvrRpqbqLei8B8EUNIXlo
	Qccg2dRYsVmw8l/poeQPnsZG6T8d1I7cxxntVJ86YYPYm+ivvKlVSxm80iL1/jXXnbZZ61X9Oxm
	M
X-Google-Smtp-Source: AGHT+IEhMBOF3tkzbu+SzQTQKLtL9/82H6m2W25m2prfPG6GqGlc3GHdj/JP3BTdeKEInpNCh6ktMg==
X-Received: by 2002:a17:906:7d48:b0:a3e:39a7:b1e7 with SMTP id l8-20020a1709067d4800b00a3e39a7b1e7mr5104946ejp.10.1708429179610;
        Tue, 20 Feb 2024 03:39:39 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id wb15-20020a170907d50f00b00a3de52ce260sm3869091ejc.200.2024.02.20.03.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 03:39:39 -0800 (PST)
Date: Tue, 20 Feb 2024 14:39:35 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org,
	smatch@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <b1167150-77ee-414c-9858-50e8c90dbd6e@moroto.mountain>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
 <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
 <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
 <uxyjkjzbur2unpdkt5yl2bojacg4tptfj6k4zyshcyvyfun3i7@y6q267iebdgg>
 <a1d5fc7c-87ac-45f5-8f3d-5af1b7cd3614@moroto.mountain>
 <jno3abkiamnwk7nqh7ojvzvrurk2ua7q3fkhnhugsxdh5vjkbh@a43f35palmkn>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jno3abkiamnwk7nqh7ojvzvrurk2ua7q3fkhnhugsxdh5vjkbh@a43f35palmkn>

On Thu, Feb 01, 2024 at 05:45:38AM -0500, Kent Overstreet wrote:
> Smatch would be more useful to me if I could just run it myself, in my
> own CI, and get results back for new code when I get the rest of my test
> results, instead of getting yanked out of my flow a week later to go
> abck and look at code I thought I was done with.

Programming Smatch is quite difficult but running Smatch is fairly easy.
It's documented in Documentation/smatch.txt.

To test the kernel it's just:
~/path/to/smatch/smatch_scripts/test_kernel.sh

Or to just test the parts you are interested in the it's:
~/path/to/smatch/smatch_scripts/kchecker fs/bcachefs/

To build the database takes maybe six hours but it's also easy enough.
~/path/to/smatch/smatch_scripts/build_kernel_data.sh

The main issue is that I'm always writting new code.  And sometimes that
code is bad.  Or sometimes I'm using a heuristic to find buggy code and
it works but not well enough to publish.  For example code like:

	if (!ret)
		return ret;

I would estimate that in new code that's going to be buggy 5-10% of the
time.  (Obviously after we fix the bugs it's 100% false positives).  I
review code like this but I try to avoid publishing checks where there
is a more than 50% false positive rate.

So right now I only have two bcache warnings.  The missing error code
warning isn't published unfortunately...  I don't think I'm going to
have a lot of time to dedicate to this stuff in the up coming months
honestly.

fs/bcachefs/journal.c:575 __journal_res_get() error: uninitialized symbol 'can_discard'.
fs/bcachefs/alloc_background.c:1751 bch2_discard_one_bucket() warn: missing error code here? 'discard_in_flight_add()' failed. 'ret' = '0'

regards,
dan carpenter
