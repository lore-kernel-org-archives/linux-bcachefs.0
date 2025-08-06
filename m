Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D8228AAE9
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 11:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754480672; cv=none; b=u6V7HV6d5IBe78VF0pnjYbi0ZRO/F0Q00ibXuo0B1j+SVwTIzrh5eb7HbAfFUMMjvjtDp4yLzNj0820T+YrpZRmhWiJLyxnnWUnFjLDVlA2agQhAITuin/TqFBYs2ZsPK1U4xqYkrTDUPw5fjlufi/mjeZoUeK/wcZ/LFEqckS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754480672; c=relaxed/simple;
	bh=TXlv470TXICOaaZTHKN/NM1+yXokyeyiY7HDpUxBeEk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bJImKDm7FKg2d/Sx8/yX9DBHVDcbIDC6BwLysYT4DsheTjlnL3MELf6732gy3rxaYwq09W8188diWG/I+jt39/zPMIl2J2XcoYjFtpbKCDGVueXbrr+VVNYQfDxEITpsyhA+0ZhK+zDFZeV0B025sXE3TaYZI9A8hXq8CjXn2A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rVuB9Su5; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rVuB9Su5"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-459d40d16bdso23473465e9.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Aug 2025 04:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754480669; x=1755085469; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aDFaERt/g6Rbj8TSlsmbOucrgXFMlT+6ugP8+VhkfCs=;
        b=rVuB9Su5y935Fc2NRMX9lXky3xWdVLnhO+m198bTvFBeQEy5O7t5sPmCXeFDc7Lga5
         wZBcNaq+kSHJ3VoX5ZNFWLQHi5hUKjUrUJrGgznOvdghItLCXD71G3aqbOTqf5EaGSuU
         3QK9/MU78l4IH//4joTbDBW1yiUICWqogFQAn+7NCbByhDStMXJcdzNAYI6QJQqvXJur
         /PYfH3AwM1GvqhbJO8+WyuCUtpyJ0iOpJ4PrH/PzDKn00QAoD/31XwrqVuHEUBXXuGOw
         ixCTpSibBONJzpfIyt9Wu6QQliJB5v7VK/UEW5+NUMAgru5XKcD5bvbLrHGuKLzHHHi6
         vw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754480669; x=1755085469;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aDFaERt/g6Rbj8TSlsmbOucrgXFMlT+6ugP8+VhkfCs=;
        b=q5v+U5fqghnLGQQ2Wbx20Y4dDcLqzfxmfPROfZYoHP7gdahah4Pg5IHRhnOHByKD/e
         knw74NKRwy1B5K7SsN9mPfov5wfcfiENLFQA8BeU4EMahhHXYwutB63BSaBaoiIjuuzH
         BVZ5RteWZmlpnrHf/Tf7lH8tB8LqrU471js11mt5rtdBJn5rrFbm2py8PcynNpsV7UkA
         TDEyQm1pTVINAIQ4tLbYXVsY7Fp1pq3/U8lzybKDQmGvVjIpxBl2XCTmIKscSXgytadp
         arjBvhd9HCwHX7U6SBORx2+Py4tjJvX5avN1phH4ZoGtkxzs9pplab3AYjox20gx20uf
         sw5Q==
X-Gm-Message-State: AOJu0YyT0M6wLGExlv2EeHwO0wWAsfOu2sSUw1rDbIE5L3xU1tRAYzMb
	Ft/mfEIS7C4Cahe/stwaTGIaXP8gwg4e82kqCBp62YofJoxdAYEKEWNvrE4oZcnjqmg=
X-Gm-Gg: ASbGncuEw+12hOoKBA7HZxnS3vDIv+3iZ4irdl6q2cNFbnzu8q9Z9n+PqWwkZJ+874f
	uMlCQUFb0ITz4LYp23/jXPvfiTsdOBYaphJxY1BNPvTD9qusPbfVtS6ZPCwjLIhOkhBeJ036tjy
	KKaXkk8oZVYjhzJsUuQVbr/wLlNmLM4IKPVZ53PgJXrcl9+BF9wNvePam9IpVcJcr6K2xeUWYCg
	+t1Y3+gxBw0EnjbZQY/saYngiDAVhT/QABaLgZA5vMDkHRm5LZ9cedUvCTtQG4MAAIbOww5mwSG
	l8EveyPqVkShhaOPYBsxUC6lGhey8uBhNpTjntLS840YLODyN2n39py9US1VPIdFD7Gm/FdhAlC
	ooi6u+uQVFlO/8ILvmI8YMvJwSgo=
X-Google-Smtp-Source: AGHT+IFEBl8Clq/1onP0j9LxeRTTtq1glGasbQ4suDrPLRAUA7Dm7P8sijtSeyVjFhotcN7WhfSpRg==
X-Received: by 2002:a05:600c:5247:b0:458:b4a6:19e9 with SMTP id 5b1f17b1804b1-459e741e79amr21939715e9.13.1754480668862;
        Wed, 06 Aug 2025 04:44:28 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e588144fsm43319145e9.28.2025.08.06.04.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 04:44:28 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:44:25 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: bch_err_throw()
Message-ID: <aJNAGQeRcXeFkaJT@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kent Overstreet,

Commit 09b9c72bd4b7 ("bcachefs: bch_err_throw()") from May 28, 2025
(linux-next), leads to the following (unpublished) Smatch static checker
warning:

	fs/bcachefs/super.c:2546 bch2_fs_open()
	warn: pointer dereferenced without being set 'c'

fs/bcachefs/super.c
    2515 struct bch_fs *bch2_fs_open(darray_const_str *devices,
    2516                             struct bch_opts *opts)
    2517 {
    2518         bch_sb_handles sbs = {};
    2519         struct bch_fs *c = NULL;
                               ^^^^^^^^^
c is NULL

    2520         struct bch_sb_handle *best = NULL;
    2521         int ret = 0;
    2522 
    2523         if (!try_module_get(THIS_MODULE))
    2524                 return ERR_PTR(-ENODEV);
    2525 
    2526         if (!devices->nr) {
    2527                 ret = -EINVAL;
    2528                 goto err;
    2529         }
    2530 
    2531         ret = darray_make_room(&sbs, devices->nr);
    2532         if (ret)
    2533                 goto err;
    2534 
    2535         darray_for_each(*devices, i) {
    2536                 struct bch_sb_handle sb = { NULL };
    2537 
    2538                 ret = bch2_read_super(*i, opts, &sb);
    2539                 if (ret)
    2540                         goto err;
    2541 
    2542                 BUG_ON(darray_push(&sbs, sb));
    2543         }
    2544 
    2545         if (opts->nochanges && !opts->read_only) {
--> 2546                 ret = bch_err_throw(c, erofs_nochanges);
                                             ^
It hasn't been set yet.

    2547                 goto err_print;
    2548         }
    2549 
    2550         darray_for_each(sbs, sb)
    2551                 if (!best || sb_cmp(sb->sb, best->sb) > 0)
    2552                         best = sb;
    2553 
    2554         darray_for_each_reverse(sbs, sb) {
    2555                 ret = bch2_dev_in_fs(best, sb, opts);
    2556 
    2557                 if (ret == -BCH_ERR_device_has_been_removed ||
    2558                     ret == -BCH_ERR_device_splitbrain) {
    2559                         bch2_free_super(sb);
    2560                         darray_remove_item(&sbs, sb);
    2561                         best -= best > sb;
    2562                         ret = 0;
    2563                         continue;
    2564                 }
    2565 
    2566                 if (ret)
    2567                         goto err_print;
    2568         }
    2569 
    2570         c = bch2_fs_alloc(best->sb, opts, &sbs);
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
set here.

    2571         ret = PTR_ERR_OR_ZERO(c);
    2572         if (ret)
    2573                 goto err;
    2574 
    2575         scoped_guard(rwsem_write, &c->state_lock)
    2576                 darray_for_each(sbs, sb) {
    2577                         ret = bch2_dev_attach_bdev(c, sb);
    2578                         if (ret)
    2579                                 goto err;
    2580                 }
    2581 
    2582         if (!c->opts.nostart) {
    2583                 ret = bch2_fs_start(c);
    2584                 if (ret)
    2585                         goto err;
    2586         }
    2587 out:
    2588         darray_for_each(sbs, sb)
    2589                 bch2_free_super(sb);
    2590         darray_exit(&sbs);
    2591         module_put(THIS_MODULE);
    2592         return c;
    2593 err_print:
    2594         pr_err("bch_fs_open err opening %s: %s",
    2595                devices->data[0], bch2_err_str(ret));
    2596 err:
    2597         if (!IS_ERR_OR_NULL(c))
    2598                 bch2_fs_stop(c);
    2599         c = ERR_PTR(ret);
    2600         goto out;
    2601 }

regards,
dan carpenter
