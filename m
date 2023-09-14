Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42F4EEAA41
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 13:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbjINNkO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 09:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239823AbjINNj7 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 09:39:59 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41BE4685
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 06:38:16 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-401d10e3e54so10165795e9.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 06:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694698695; x=1695303495; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fv6FKFv/jBOjnIf/6uRVzOJkQy722EOM6kgAlH3wVcI=;
        b=RzgmUlRlkFuFNjRUHxXRwdQYDrFVfAm/cGB5Q4LzLlPhGFw13CqDZORDn3BcO2RBF2
         y0LGhNS8pLmnYtHhwaXZWlrUQ4sfr1VSieYnuE06OYsSl/OC35hBbpInCqIU7QnYOioK
         uHr/WIsFMKzoLfpFEUtg8pBmySAzafUxmtKQy1LINYRtMrMrU1W62J4tcgbe0tFAequN
         3T4vf3k7erUCCceHmo8TSDuRlhkHmD/HOmR08+VndWF90gvVL8Srh+3Vrz6TudpSsC2z
         W7CP0CeK+MOEujskc5b96+P9vjWHEl0hEvs179GSzDBbYHzpFkUKt5NmiMjjwnn+7BNU
         9jRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694698695; x=1695303495;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fv6FKFv/jBOjnIf/6uRVzOJkQy722EOM6kgAlH3wVcI=;
        b=QC7f2B4MYnVrIFdTfcfhmwYYNDRmDLUaTKKnZDpoC2FSIbc+IlMBAoKWzCI+sRiUFL
         Vgrk9mKKWBfBSNWI1ZsEsnkqV3HaH7p/FQTQ8HPsPZD/AgyWQt9sv46dPzokdaeL4xaM
         4e+U/JaE76UPoMhxjlx4blSVM4+37qQn/mMOQ7ImFQ35vEHBqcsTeYXv83BvcoexpeGE
         g2v88P+YzcPEUcTk4292bssOs6HIogATG5ePRtB+VhXYt9pmX2hsSQMvYJ6ZkaPYFRX3
         O+sZTPOBng6LiLpp3N3AucMsuwQvNy42+5F9i1caSghUcZpj0BJ0Dwo1Qn7Y4T7IC340
         mbDw==
X-Gm-Message-State: AOJu0YwI/MMYC4GSnEO72vaj/G3bohQaN+LMRdI4mhSXNskmiM5ufWiz
        59EoWfPccImTnS+epwYrnTo2vhZ8tvtbGpaGSBE=
X-Google-Smtp-Source: AGHT+IFeCkRrb1QV7ffrmIdJHRkoecpLS5YpDYGJyeutn4gLL5i6s8NhdduagxbDBlMLNMbjRQfhtg==
X-Received: by 2002:a1c:7407:0:b0:401:d803:6241 with SMTP id p7-20020a1c7407000000b00401d8036241mr4697650wmc.21.1694698695250;
        Thu, 14 Sep 2023 06:38:15 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y14-20020a5d4ace000000b003176eab8868sm1835558wrs.82.2023.09.14.06.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 06:38:14 -0700 (PDT)
Date:   Thu, 14 Sep 2023 16:38:11 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@gmail.com
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: Kill bch2_fs_usage_scratch_get()
Message-ID: <b4f209ea-fdf6-412c-98bd-7be52b54447b@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch 502bed819cc3: "bcachefs: Kill bch2_fs_usage_scratch_get()"
from Apr 3, 2021 (linux-next), leads to the following Smatch static
checker warning:

	fs/bcachefs/buckets.c:1352 bch2_trans_fs_usage_apply()
	error: we previously assumed 'trans->disk_res' could be null (see line 1302)

fs/bcachefs/buckets.c
    1296 int bch2_trans_fs_usage_apply(struct btree_trans *trans,
    1297                               struct replicas_delta_list *deltas)
    1298 {
    1299         struct bch_fs *c = trans->c;
    1300         static int warned_disk_usage = 0;
    1301         bool warn = false;
    1302         unsigned disk_res_sectors = trans->disk_res ? trans->disk_res->sectors : 0;
                                             ^^^^^^^^^^^^^^^
This code is quite subtle, but the static checker says that we check
for NULL here.

    1303         struct replicas_delta *d = deltas->d, *d2;
    1304         struct replicas_delta *top = (void *) deltas->d + deltas->used;
    1305         struct bch_fs_usage *dst;
    1306         s64 added = 0, should_not_have_added;
    1307         unsigned i;
    1308 
    1309         percpu_down_read(&c->mark_lock);
    1310         preempt_disable();
    1311         dst = fs_usage_ptr(c, trans->journal_res.seq, false);
    1312 
    1313         for (d = deltas->d; d != top; d = replicas_delta_next(d)) {
    1314                 switch (d->r.data_type) {
    1315                 case BCH_DATA_btree:
    1316                 case BCH_DATA_user:
    1317                 case BCH_DATA_parity:
    1318                         added += d->delta;

And we set added to non-zero here so that doesn't seem related.  Or the
relationship is not obvious.

    1319                 }
    1320 
    1321                 if (__update_replicas(c, dst, &d->r, d->delta))
    1322                         goto need_mark;
    1323         }
    1324 
    1325         dst->nr_inodes += deltas->nr_inodes;
    1326 
    1327         for (i = 0; i < BCH_REPLICAS_MAX; i++) {
    1328                 added                                += deltas->persistent_reserved[i];
    1329                 dst->reserved                        += deltas->persistent_reserved[i];
    1330                 dst->persistent_reserved[i]        += deltas->persistent_reserved[i];
    1331         }
    1332 
    1333         /*
    1334          * Not allowed to reduce sectors_available except by getting a
    1335          * reservation:
    1336          */
    1337         should_not_have_added = added - (s64) disk_res_sectors;
    1338         if (unlikely(should_not_have_added > 0)) {
    1339                 u64 old, new, v = atomic64_read(&c->sectors_available);
    1340 
    1341                 do {
    1342                         old = v;
    1343                         new = max_t(s64, 0, old - should_not_have_added);
    1344                 } while ((v = atomic64_cmpxchg(&c->sectors_available,
    1345                                                old, new)) != old);
    1346 
    1347                 added -= should_not_have_added;
    1348                 warn = true;
    1349         }
    1350 
    1351         if (added > 0) {
--> 1352                 trans->disk_res->sectors -= added;
                         ^^^^^^^^^^^^^^^^^
Unchecked dereference.

    1353                 this_cpu_sub(*c->online_reserved, added);
    1354         }
    1355 
    1356         preempt_enable();
    1357         percpu_up_read(&c->mark_lock);
    1358 
    1359         if (unlikely(warn) && !xchg(&warned_disk_usage, 1))
    1360                 bch2_trans_inconsistent(trans,
    1361                                         "disk usage increased %lli more than %u sectors reserved)",
    1362                                         should_not_have_added, disk_res_sectors);
    1363         return 0;
    1364 need_mark:
    1365         /* revert changes: */
    1366         for (d2 = deltas->d; d2 != d; d2 = replicas_delta_next(d2))
    1367                 BUG_ON(__update_replicas(c, dst, &d2->r, -d2->delta));
    1368 
    1369         preempt_enable();
    1370         percpu_up_read(&c->mark_lock);
    1371         return -1;
    1372 }

regards,
dan carpenter
