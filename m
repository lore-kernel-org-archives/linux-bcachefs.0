Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA87EB64D7
	for <linux-bcachefs@archiver.kernel.org>; Tue, 27 Jun 2023 01:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjF0BN7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 26 Jun 2023 21:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjF0BN6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 26 Jun 2023 21:13:58 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80146173E
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 Jun 2023 18:13:56 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-656bc570a05so1036841b3a.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 Jun 2023 18:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687828436; x=1690420436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MQ/IjqmtE16kQNQEnAAcOTmBTtwuTHwVotfjuZpxuOk=;
        b=Qh0TdwgR7cXBEXeK5cmdtXosn/XHZ8bChAZlYL8hsZEzYoduf1shHWb2RecxQZPqSU
         55krgRpDZFhTfysMsHQDkUAZN/Hy8ArK0LNqNRaPnPwhyEvKBgsQCMlI1t+T8e2m8Jnn
         yS5m0VEHcx726/05Gh/CaTA+PBBY5HkCFo3lP3mpj3cpYcWS7MoE14Rqx2zXa9Dgh6eP
         RzOu4++eXsf2wbFJ6ySIqQSLHaVfhmoErl9f8ohuehHLV8iLqmrpl2SGqUYAM4GqSy01
         Bcr2IiFeqqaX3NMqn0dqGEXRXDy/wy6AeSBsLKv8mbvK1Ro+WWRzA1tE1ijjAFP4KcFs
         Arww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687828436; x=1690420436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MQ/IjqmtE16kQNQEnAAcOTmBTtwuTHwVotfjuZpxuOk=;
        b=Tre6zchh8XTVus4j8s0c2VNsJ5W1cgEjGfcf3qNkULSO/AMk+BIBIY+u11+ViIH6/E
         izai4d257X18Oikd6rhkNXq5ewlJa87HKtUGt59XcC/FFIIJ4Y3/yL0MwneMGQmBc5HJ
         EkvRoJkCOtwK6pDysf1G8UtbOzWqCjnIIWdtXyaIsUfdc1BG9AmZS1C5xbHao2rovJOJ
         MZnEx6tVjZR6My0V2w1vpCCQDs+Hj0k9IprNVzz639aOPlE1/tF+6T8S6GRmMKFUzpHy
         VFkwjOfqtCLSdeAKNhN+LM5TF3WFoghfi8jyA1LP6/zAqqo9EIzzFy1BmjbtOIYqv4qu
         fmgg==
X-Gm-Message-State: AC+VfDz/iwQ5hqRURUXkj1RII3lzMhvlQl8pVW6G6KrxHA7AXIo6jOcg
        ihXdGF3hAC408HcgBS+llqr9vQ==
X-Google-Smtp-Source: ACHHUZ6Hji3PWg/+1y1c/8GC5/7oraS0lnPCcB+YX5+KRwILp3HpyMg3HHBinA0tMs9CT3eKf+vs5Q==
X-Received: by 2002:a05:6a21:6d9c:b0:125:6443:4eb8 with SMTP id wl28-20020a056a216d9c00b0012564434eb8mr17562093pzb.5.1687828435896;
        Mon, 26 Jun 2023 18:13:55 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z15-20020a170903018f00b001a072aedec7sm4754717plg.75.2023.06.26.18.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 18:13:55 -0700 (PDT)
Message-ID: <91e9064b-84e3-1712-0395-b017c7c4a964@kernel.dk>
Date:   Mon, 26 Jun 2023 19:13:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] bcachefs
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <aeb2690c-4f0a-003d-ba8b-fe06cd4142d1@kernel.dk>
 <20230627000635.43azxbkd2uf3tu6b@moria.home.lan>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230627000635.43azxbkd2uf3tu6b@moria.home.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 6/26/23 6:06?PM, Kent Overstreet wrote:
> On Mon, Jun 26, 2023 at 05:11:29PM -0600, Jens Axboe wrote:
>>> (Worth noting the bug causing the most test failures by a wide margin is
>>> actually an io_uring bug that causes random umount failures in shutdown
>>> tests. Would be great to get that looked at, it doesn't just affect
>>> bcachefs).
>>
>> Maybe if you had told someone about that it could get looked at?
> 
> I'm more likely to report bugs to people who have a history of being
> responsive...

I maintain the code I put in the kernel, and generally respond to
everything, and most certainly bug reports.

>> What is the test case and what is going wrong?
> 
> Example: https://evilpiepirate.org/~testdashboard/c/82973f03c0683f7ecebe14dfaa2c3c9989dd29fc/xfstests.generic.388/log.br
> 
> I haven't personally seen it on xfs - Darrick knew something about it
> but he's on vacation. If I track down a reproducer on xfs I'll let you
> know.
>
> If you're wanting to dig into it on bcachefs, ktest is pretty easy to
> get going: https://evilpiepirate.org/git/ktest.git
> 
>   $ ~/ktest/root_image create
>   # from your kernel tree:
>   $ ~/ktest/build-test-kernel run -ILP ~/ktest/tests/bcachefs/xfstests.ktest/generic/388
> 
> I have some debug code I can give you from when I was tracing it through
> the mount path, I still have to find or recreate the part that tracked
> it down to io_uring...

Doesn't reproduce for me with XFS. The above ktest doesn't work for me
either:

~/git/ktest/build-test-kernel run -ILP ~/git/ktest/tests/bcachefs/xfstests.ktest/generic/388
realpath: /home/axboe/git/ktest/tests/bcachefs/xfstests.ktest/generic/388: Not a directory
Error 1 at /home/axboe/git/ktest/build-test-kernel 262 from: ktest_test=$(realpath "$1"), exiting

and I suspect that should've been a space, but:

~/git/ktest/build-test-kernel run -ILP ~/git/ktest/tests/bcachefs/xfstests.ktest generic/388
Running test xfstests.ktest on m1max at /home/axboe/git/linux-block
No tests found
TEST FAILED

If I just run generic/388 with bcachefs formatted drives, I get xfstests
complaining as it tries to mount an XFS file system...

As a side note, I do get these when compiling:

fs/bcachefs/alloc_background.c: In function ‘bch2_check_alloc_info’:
fs/bcachefs/alloc_background.c:1526:1: warning: the frame size of 2640 bytes is larger than 2048 bytes [-Wframe-larger-than=]
 1526 | }
      | ^
fs/bcachefs/reflink.c: In function ‘bch2_remap_range’:
fs/bcachefs/reflink.c:388:1: warning: the frame size of 2352 bytes is larger than 2048 bytes [-Wframe-larger-than=]
  388 | }
      | ^


-- 
Jens Axboe

