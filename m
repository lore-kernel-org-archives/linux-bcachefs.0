Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C9A28C2A5
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 11:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754480667; cv=none; b=IGz3LzH8uA7uoNALWqObsaKEIRCn285NMBUZDiUH7s4cGECaoiLtT1XXxXM9Ej6SPqjyBcgI7EBPqwPBhqoUWbz5MeS0BxjPswTomHcv4kR1Xh3wu6S6hbfInmWLka0ZC0RUn0UpJzryOXQOVCtDmvgNOT5TzWP8fxhtLKKXzK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754480667; c=relaxed/simple;
	bh=ecH05f2TRWbuvMQG7DEEF1q8CP35pfMe6pKQpxdfsJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=h5q1a/fexiYkWrZIVL7R/3UgbnJRmkdMiRZZ7KnJMGbseonO8HNjLEHLUOrO20Dwkljdk0VQ0WCgDQzZHcpO0zyhIbnyUDyG0/0Ao49ngy5qGUjUxVusUuEpDWIVtNgwlifst3Q/BG+xMxTR59LP0bLm1ooL0dMDIk5G7q42X7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BTv3zMAL; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BTv3zMAL"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b79bd3b1f7so3643560f8f.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Aug 2025 04:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754480664; x=1755085464; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c+26/aWNec7lOubZACnSbBAe4v1UKfeem6wCYnlwsGw=;
        b=BTv3zMAL9vqDjR+ghKRjpYhSTHDfpqp2Hfi0KjRa2LpRsDc711iOtEe37qdvuKPlnF
         7oW2erk6LVU107B5np5ZB3wIst5SM5lU2eV6nMAm3VFmGkmfPeKYlgwJAzPxzqKnrKkV
         WS14pP9MjRDx69iBPKUX95d7knIO2Zjk6uZOkupjdDxSWY16MepPm1oU0YkohLZ69Giv
         0wEk+7hb19GHkDCAeuZqWvZxafUmOM1TFEmgiiRj53yOFrkkHyZY8mOEkg9NckYiLWU2
         9oa6O8J2cOR+ReK9xCRl+8ifam4gNeS+1/H+v1ckW0MSphMaYwIq7V4CWMQsKCkzBAGQ
         wv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754480664; x=1755085464;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c+26/aWNec7lOubZACnSbBAe4v1UKfeem6wCYnlwsGw=;
        b=sqEGaRk8C36sM9NOkzfUMlXT+jpaGSruryTfP14PbeX1/j/LaF6u5Qyvp6M5OKXPCV
         Zs8HMqMuFnfAwdx2IzIpgleLUGegAGc5U11SkjNnKSZdnIWDwNzmM3qSVjyBXzm3Q98c
         jd/eqpJp4TSL+UqSl7cHj4N+W7pQDGMRqCChwoSZ1+UPSnx4epqgpuvN0p/WsKQsjYUr
         zAJ86pLaXryKNjxJvvRa2r9qZbr8ASXspww8HGFPsi3inIpbm7Xo/P8XUGMf7tr2Rq3r
         mYNhU5CI7P3Guo3cqk6M/CCIp4hs6aGlTXCzAl2NFxDbNPUywbZIvimuVN/BWkdTaFT1
         W9BQ==
X-Gm-Message-State: AOJu0YyntFXbCr+R/AiSBNq4EZemNu+2K9ff+XDDFOmAGHcpMJjt8Kc1
	PtTQ8mGXSy/jcDfE/bGKtlWwMC0brKCFavbDO+qyUFtoNhw9U1Id/hoN0bCkkFesmMs=
X-Gm-Gg: ASbGncsx03Ks4qA9BgtJq0kaQi21jqbRjVvTLgMnQM+ysXluCyi84uOK2UbX8lIpuOM
	GKmSvyyteS7uuCfV91Na9NJfC7hnFUCNs/ZoMCL/6Kd6BrwRqWdK9bX92MIEZEw+y8OzzGxCviG
	xlSILo1DefOTM2Mci1BlZCbnhnCbF/X8iuDfpo77Tuy2B1pFfcPyRdzt0tEwNbEtomKW3d2w32z
	NOGy97raIrTWmM2CJpNUdliWjEzdgSDEBp8fRjkbJoNynIu3/FF+qkTbeF4GbUbb7QWB34TYKKH
	+g8XKZMUSqQ2LtuRIdYOMkKljuQcnpmj6pc/+hi+o/jTmtd75N2vIKcJKjxgHua71FHywG+bwSR
	VfpfpwMgHuOPMhbHg5qx4c4Z7J08=
X-Google-Smtp-Source: AGHT+IGlKDkAlKU3W0cih1XUDd81DLjIaPrsvmoOGH/hQqlEUYB2KZHcDw9ZosXsTBCSwRebU7y7LA==
X-Received: by 2002:a5d:5f49:0:b0:3b7:8481:e365 with SMTP id ffacd0b85a97d-3b8f418ac86mr1863178f8f.10.1754480663676;
        Wed, 06 Aug 2025 04:44:23 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e5b84674sm46996765e9.30.2025.08.06.04.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 04:44:23 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:44:19 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: bch_err_throw()
Message-ID: <aJNAE5KV22lYAq_A@stanley.mountain>
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
(linux-next), leads to the following Smatch static checker warning:

	fs/bcachefs/journal_sb.c:213 bch2_journal_buckets_to_sb()
	error: we previously assumed 'c' could be null (see line 197)

fs/bcachefs/journal_sb.c
    191 int bch2_journal_buckets_to_sb(struct bch_fs *c, struct bch_dev *ca,
    192                                u64 *buckets, unsigned nr)
    193 {
    194         struct bch_sb_field_journal_v2 *j;
    195         unsigned i, dst = 0, nr_compacted = 1;
    196 
    197         if (c)
                ^^^^^^
Here we assume c can be NULL.

    198                 lockdep_assert_held(&c->sb_lock);
    199 
    200         if (!nr) {
    201                 bch2_sb_field_delete(&ca->disk_sb, BCH_SB_FIELD_journal);
    202                 bch2_sb_field_delete(&ca->disk_sb, BCH_SB_FIELD_journal_v2);
    203                 return 0;
    204         }
    205 
    206         for (i = 0; i + 1 < nr; i++)
    207                 if (buckets[i] + 1 != buckets[i + 1])
    208                         nr_compacted++;
    209 
    210         j = bch2_sb_field_resize(&ca->disk_sb, journal_v2,
    211                          (sizeof(*j) + sizeof(j->d[0]) * nr_compacted) / sizeof(u64));
    212         if (!j)
--> 213                 return bch_err_throw(c, ENOSPC_sb_journal);
                                             ^
The patch adds an unchecked dereference

    214 
    215         bch2_sb_field_delete(&ca->disk_sb, BCH_SB_FIELD_journal);
    216 
    217         j->d[dst].start = cpu_to_le64(buckets[0]);
    218         j->d[dst].nr        = cpu_to_le64(1);
    219 
    220         for (i = 1; i < nr; i++) {
    221                 if (buckets[i] == buckets[i - 1] + 1) {
    222                         le64_add_cpu(&j->d[dst].nr, 1);
    223                 } else {
    224                         dst++;
    225                         j->d[dst].start = cpu_to_le64(buckets[i]);
    226                         j->d[dst].nr        = cpu_to_le64(1);
    227                 }
    228         }
    229 
    230         BUG_ON(dst + 1 != nr_compacted);
    231         return 0;
    232 }

regards,
dan carpenter
