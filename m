Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0515EB64D7
	for <linux-bcachefs@archiver.kernel.org>; Mon, 26 Jun 2023 23:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjFZXLe (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 26 Jun 2023 19:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjFZXLd (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 26 Jun 2023 19:11:33 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BEC1702
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 Jun 2023 16:11:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b8053aece3so2303025ad.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 Jun 2023 16:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687821091; x=1690413091;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4CPuQ5HYLfaP9JIMxrmKe7n4kIln48bN6Na9rBaA1Bc=;
        b=Mf0wsMXIpm+R4t+5rDb4/Ck9+QwFYPT5/nb527wI4PfBMEcQfxvBCiige+M1YtFTRN
         J0CQ2au30YqMbKQaRVsev/noR8phdU1Lo3k0kbnQureJDjYEdS9d2eN8bmP9rUmMhGS6
         xhzJTI/UH6e6ACuOjOPe4mO6sDURwj8BiNepVRXlEZhZ30/2dEvQimSnLoFEgJ0LvqTb
         rvW8FSRDSS7ITjan3+RKrbrFgGUc3WzRXFP76knXhXas+Omx6gzDzaSLlF0KOP1Ml+G3
         B5TaEzZjqVQwLEcK8rOAV4leSVVbwWNpCohZzhYcg6fL++KtaN+0NZ8FkyJQ7dqXQafa
         OTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687821091; x=1690413091;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CPuQ5HYLfaP9JIMxrmKe7n4kIln48bN6Na9rBaA1Bc=;
        b=kBNiXieBT5NFMBwVYEN9/SOqk28Eq500X3ebCw6dSQYbQ0m8EVG1MZ4k7Zn8Bk5zyY
         C3+pmQcQHHjc9B6cJe9kEe14UEzds0e+0x/kDc3DGvmhgCvRo1vGp+iBn10LsXv6jVUU
         qzfQG3ZhQG3BmuVXJZISYDwp9x9Fjc46CuXj1paR60boqOttFR3juagivMVlQHq+HCpY
         kFrrCoqtD9OKSb9RFKIH/TU2lDH65jqD/tsLLtJ+AVEVqNMd6QrLHNo3O6ISg7brZGgZ
         CTMUm2yP4qUNW59k+b/KQ3Apn6rzOl66bhZ5hFxa5YQ8JSQGarJL5JRWdJYp4+FHPsio
         YtVA==
X-Gm-Message-State: AC+VfDz3WwuHhyEXUaBrqmIEjedyb8FBOWUB6mlnuO393h3BT8jD/MtR
        dhmjCpTYwm3JA+kT8QE1OVFupw==
X-Google-Smtp-Source: ACHHUZ6v/dvpLfopQ3/7RYntaktPdFwjv+AD316VSdGbHxUx/tr7wrQMmGiHs7lMRnYCwERDpyVAaw==
X-Received: by 2002:a17:902:f984:b0:1b8:811:b05a with SMTP id ky4-20020a170902f98400b001b80811b05amr3995296plb.6.1687821091356;
        Mon, 26 Jun 2023 16:11:31 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g7-20020a1709026b4700b001b7f40a8959sm3338143plt.76.2023.06.26.16.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 16:11:30 -0700 (PDT)
Message-ID: <aeb2690c-4f0a-003d-ba8b-fe06cd4142d1@kernel.dk>
Date:   Mon, 26 Jun 2023 17:11:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] bcachefs
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
Content-Language: en-US
In-Reply-To: <20230626214656.hcp4puionmtoloat@moria.home.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

> (Worth noting the bug causing the most test failures by a wide margin is
> actually an io_uring bug that causes random umount failures in shutdown
> tests. Would be great to get that looked at, it doesn't just affect
> bcachefs).

Maybe if you had told someone about that it could get looked at?
What is the test case and what is going wrong?

>       block: Add some exports for bcachefs
>       block: Allow bio_iov_iter_get_pages() with bio->bi_bdev unset
>       block: Bring back zero_fill_bio_iter
>       block: Don't block on s_umount from __invalidate_super()

OK...

-- 
Jens Axboe


