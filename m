Return-Path: <SRS0=iM4m=B2=vger.kernel.org=linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48F4C433DF
	for <linux-bcachefs@archiver.kernel.org>; Sun, 16 Aug 2020 09:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF31F20674
	for <linux-bcachefs@archiver.kernel.org>; Sun, 16 Aug 2020 09:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgHPJq1 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 16 Aug 2020 05:46:27 -0400
Received: from relay-b01.edpnet.be ([212.71.1.221]:38488 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgHPJqZ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 16 Aug 2020 05:46:25 -0400
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Aug 2020 05:46:21 EDT
X-ASG-Debug-ID: 1597571180-0a7ff52e9b345ea0001-qsCQDO
Received: from [192.168.177.100] (213.219.167.75.bro01.dyn.edpnet.net [213.219.167.75]) by relay-b01.edpnet.be with ESMTP id lLce9Ia53BLEzj3A for <linux-bcachefs@vger.kernel.org>; Sun, 16 Aug 2020 11:46:20 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.167.75.bro01.dyn.edpnet.net[213.219.167.75]
X-Barracuda-Apparent-Source-IP: 213.219.167.75
Subject: Re: [PATCH][2/2] adjustments for 5.8
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
X-ASG-Orig-Subj: Re: [PATCH][2/2] adjustments for 5.8
To:     linux-bcachefs@vger.kernel.org
References: <6dcb185b-807b-ded8-3fad-245ce9fd2e13@kabelmail.de>
Autocrypt: addr=janpieter.sollie@kabelmail.de; prefer-encrypt=mutual; keydata=
 mQENBFhRXM0BCADnifwYnfbhQtJso1eeT+fjEDJh8OY5rwfvAbOhHyy003MJ82svXPmM/hUS
 C6hZjkE4kR7k2O2r+Ev6abRSlM6s6rJ/ZftmwOA7E8vdSkrFDNqRYL7P18+Iq/jM/t/6lsZv
 O+YcjF/gGmzfOCZ5AByQyLGmh5ZI3vpqJarXskrfi1QiZFeCG4H5WpMInml6NzeTpwFMdJaM
 JCr3BwnCyR+zeev7ROEWyVRcsj8ufW8ZLOrML9Q5QVjH7tkwzoedOc5UMv80uTaA5YaC1GcZ
 57dAna6S1KWy5zx8VaHwXBwbXhDHWvZP318um2BxeTZbl21yXJrUMbYpaoLJzA5ZaoCFABEB
 AAG0MEphbnBpZXRlciBTb2xsaWUgPGphbnBpZXRlci5zb2xsaWVAa2FiZWxtYWlsLmRlPokB
 VAQTAQgAPgIbIwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBGBBYpsrUd7LDG6rUrFUjEUP
 H5JbBQJejDNwBQkPoNgdAAoJELFUjEUPH5Jb/TYH/3vHwn78OjEcJPtQqZ/vdydxGVZaO3mF
 ZbQsejrm/W1N72tfQRvJwuBg7VXO+n2++1SJCnGgjKxo0MwoJwqPkxbQeM3Gjl0/HHNMN+Lz
 lH5jWn81sgjIcK6ac8LRsFsJBz6fvxFdS3+cP4DqcpPhl8b9ZMMhQdTgUZtGBuryoHgdQpBl
 0BV+qxTDsYs0tir+cZMCPR/JUAnYlC471mRC27Bl8tDDiQLBPYNIOi9eeV4wVumznf9XZV2R
 yDop44jIxbcFECr3cyuM1GZI9KWKA5qZmDTWqvHS6Q0Ns5x+wT2knTrUzvVHbD6b1Hw6c0gR
 3FaOSPfy1U2bbC2P1mTEvWO5AQ0EWFFczQEIAPZ8mQJATotSNSlWW3NePF5FM1Ar9bc8LWLc
 SyMcVIlPTgxjXbOZdYjQi02qdFoHZz9f+u1ZO5hrNKyBBNA/+plK2zbz3QYPnXLcEDDjjes3
 SmVWnh1fokb+ndXSFrutfAWOfgfOC3ggMlJW41r2cYRx4h2pOe9k74Xi6SDNXZhUBRZy4OjA
 IEN9GbfJTQZTevE4d8FOljCWOoVZsaqKOxOMXX8t7hQsX6odRCrBMNjWKOnFEIh67jpahAR/
 kO/RpMjA4mA8rzbb25EMeUeEw+9emq0FgrBD+s4LPsR8hMOU+weGOepH6aN4vLu0r+ojJoTs
 DwdN2jFihiEBH4CrKVEAEQEAAYkBPAQYAQgAJgIbDBYhBGBBYpsrUd7LDG6rUrFUjEUPH5Jb
 BQJejDNwBQkPoNgjAAoJELFUjEUPH5JbUncIAMrv2TdPUtqMQdkaTFY+gC6LE3wXql/uGeh+
 hHYoWQxtCT71Zh+Iaw5xnAmOJTJCCJpJlx3PpAaQY8ON8suI0Mq8YYYCBFP32u4Di7J8BeM5
 tusynxUavR8jp5EXeda6HlGThbYNj/CNrKADQUn++nDxcWz03Jxi+TvI9xdbb03r/npMhzUj
 tLGawTPCuIbG+5E1kHO42wS92DOQXSRMvicyEf+iU8VbX5/ZjSQDdoBrVnKPMeyANQFIrK/f
 kwlHE8uQsrgj/kOKw1+N/KAT+C9KH4iyz5mq1mFjNH2gDqSaDushBod5U04HAWyaQeZcOYfl
 t4ImyAHqHDGJABRo5o4=
Message-ID: <8365d24a-e3ca-ebf9-be61-79b2205cded0@kabelmail.de>
Date:   Sun, 16 Aug 2020 11:46:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6dcb185b-807b-ded8-3fad-245ce9fd2e13@kabelmail.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: 213.219.167.75.bro01.dyn.edpnet.net[213.219.167.75]
X-Barracuda-Start-Time: 1597571180
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 7572
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.5189 1.0000 0.7500
X-Barracuda-Spam-Score: 1.25
X-Barracuda-Spam-Status: No, SCORE=1.25 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.83934
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-bcachefs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

in order to restore functionality of the add_to_page_cache_vec in file mm/filemap.c, the follow
patch should also be applied:


diff --git a/mm/filemap.c b/mm/filemap.c
index d39a3f28d6a9..d58e1bc46d3b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -903,8 +904,8 @@ static int add_to_page_cache_vec(struct page **pages, unsigned nr_pages,
                VM_BUG_ON_PAGE(PageSwapCache(page), page);
 
                if (!PageHuge(page)) {
-                       error = mem_cgroup_try_charge(page, current->mm,
-                                                     gfp_mask, &memcg, false);
+                       error = mem_cgroup_charge(page, current->mm,
+                                                     gfp_mask);
                        if (error) {
                                if (!i)
                                        return error;
@@ -928,10 +929,6 @@ static int add_to_page_cache_vec(struct page **pages, unsigned nr_pages,
 
        for (i = 0; i < nr_added; i++) {
                struct page *page = pages[i];
-
-               if (!PageHuge(page))
-                       mem_cgroup_commit_charge(page, memcg, false, false);
-
                trace_mm_filemap_add_to_page_cache(page);
        }
 
@@ -939,7 +936,7 @@ static int add_to_page_cache_vec(struct page **pages, unsigned nr_pages,
                struct page *page = pages[i];
 
                if (!PageHuge(page))
-                       mem_cgroup_cancel_charge(page, memcg, false);
+                       mem_cgroup_uncharge(page);
 
                /* Leave page->index set: truncation relies upon it */
                page->mapping = NULL;


Op 2020-08-16 om 11:35 schreef Janpieter Sollie:
> Hi,
>
>
> Hereby some patches for review of the implementation of v5.8
>
> I explicitly included the KERNEL_VERSION header (which is probably not needed, since it's an
> in-tree driver) as the current version is 5.7, so once the 5.8 bump has been applied, the
> KERNEL_VERSION statement should be removed.
>
>
> Janpieter
>
>
> diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
> index a0d570f3adf0..cdc85423826c 100644
> --- a/fs/bcachefs/btree_cache.c
> +++ b/fs/bcachefs/btree_cache.c
> @@ -7,6 +7,7 @@
>  #include "btree_locking.h"
>  #include "debug.h"
>  
> +#include <linux/version.h>
>  #include <linux/prefetch.h>
>  #include <linux/sched/mm.h>
>  #include <trace/events/bcachefs.h>
> @@ -85,8 +86,12 @@ static int btree_node_data_alloc(struct bch_fs *c, struct btree *b, gfp_t gfp)
>         if (!b->data)
>                 return -ENOMEM;
>  
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0))
>         b->aux_data = __vmalloc(btree_aux_data_bytes(b), gfp,
>                                 PAGE_KERNEL_EXEC);
> +#else
> +       b->aux_data = __vmalloc(btree_aux_data_bytes(b), gfp);
> +#endif
>         if (!b->aux_data) {
>                 kvpfree(b->data, btree_bytes(c));
>                 b->data = NULL;
> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> index d73cc8ddadac..8b4bb75344ba 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -10,6 +10,7 @@
>  #include "journal_reclaim.h"
>  
>  #include <trace/events/bcachefs.h>
> +#include <linux/version.h>
>  
>  static int bch2_btree_key_cache_cmp_fn(struct rhashtable_compare_arg *arg,
>                                        const void *obj)
> @@ -391,7 +392,11 @@ static void btree_key_cache_journal_flush(struct journal *j,
>         struct btree_trans trans;
>  
>         six_lock_read(&ck->c.lock, NULL, NULL);
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0))
>         key = READ_ONCE(ck->key);
> +#else
> +       key = __READ_ONCE(ck->key);
> +#endif
>  
>         if (ck->journal.seq != seq ||
>             !test_bit(BKEY_CACHED_DIRTY, &ck->flags)) {
> diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
> index 951a436195ee..b4f73d9e74ea 100644
> --- a/fs/bcachefs/fs-io.c
> +++ b/fs/bcachefs/fs-io.c
> @@ -20,11 +20,15 @@
>  #include "quota.h"
>  #include "reflink.h"
>  
> +#include <linux/version.h>
>  #include <linux/aio.h>
>  #include <linux/backing-dev.h>
>  #include <linux/falloc.h>
>  #include <linux/migrate.h>
>  #include <linux/mmu_context.h>
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(5,8,0))
> +#include <linux/kthread.h>
> +#endif
>  #include <linux/pagevec.h>
>  #include <linux/sched/signal.h>
>  #include <linux/task_io_accounting_ops.h>
> @@ -1819,7 +1823,11 @@ static long bch2_dio_write_loop(struct dio_write *dio)
>  
>         while (1) {
>                 if (kthread)
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0))
>                         use_mm(dio->mm);
> +#else
> +                       kthread_use_mm(dio->mm);
> +#endif
>                 BUG_ON(current->faults_disabled_mapping);
>                 current->faults_disabled_mapping = mapping;
>  
> @@ -1827,8 +1835,11 @@ static long bch2_dio_write_loop(struct dio_write *dio)
>  
>                 current->faults_disabled_mapping = NULL;
>                 if (kthread)
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0))
>                         unuse_mm(dio->mm);
> -
> +#else
> +                       kthread_unuse_mm(dio->mm);
> +#endif
>                 if (unlikely(ret < 0))
>                         goto err;
>  
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index a47923d67f7a..865619d0d2f0 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -22,6 +22,7 @@
>  #include "super.h"
>  #include "xattr.h"
>  
> +#include <linux/fiemap.h>
>  #include <linux/aio.h>
>  #include <linux/backing-dev.h>
>  #include <linux/exportfs.h>
> diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
> index 4dcd28456e00..4ae1d2a82ea6 100644
> --- a/fs/bcachefs/util.h
> +++ b/fs/bcachefs/util.h
> @@ -2,6 +2,7 @@
>  #ifndef _BCACHEFS_UTIL_H
>  #define _BCACHEFS_UTIL_H
>  
> +#include <linux/version.h>
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
>  #include <linux/closure.h>
> @@ -99,7 +100,11 @@ static inline void *vpmalloc(size_t size, gfp_t gfp_mask)
>  {
>         return (void *) __get_free_pages(gfp_mask|__GFP_NOWARN,
>                                          get_order(size)) ?:
> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0))
>                 __vmalloc(size, gfp_mask, PAGE_KERNEL);
> +#else
> +               __vmalloc(size, gfp_mask);
> +#endif
>  }
>  
>  static inline void kvpfree(void *p, size_t size)
>

