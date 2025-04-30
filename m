Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B5F264637
	for <linux-bcachefs@vger.kernel.org>; Wed, 30 Apr 2025 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746037665; cv=none; b=RPDhCXgpHF+nnPkZKZ+gkCEjDxjCFzlfH3zGoshva4DJBtGXoCpnPLOz77G4Rm+TZGemzzRL+nAA5+/PTdfYobzoNDXXMXFuvvOhX6T7XZLb/nV8CjF1NI5k8TJ+PMK1wwfkTdPJPV11rJdonwdCHaw8CUCU9xC/antDX/Bm2HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746037665; c=relaxed/simple;
	bh=nNyRbhoQ6hDPbyGYMQxS21MrhqYv/wuN5Nmm5p8+wko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f2DXDvdX2JuKx0sOHqQsGbSLVa4JXewfCDDvGi/oJ6FJ6smIByB+mPVfirxpzdqaoazx9Kw6/xHSnQ8pmPFqxtgYKY2vP00+YjZoXlbYgvK2qh6s1VMG3kuLWXQz/CQzu02Mj7SJvNfgPEWi57DN9tafyxL9H22iQgJc854TtBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=RToXduq7; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="RToXduq7"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id A3r1uKhvAMETlAC9euQNSV; Wed, 30 Apr 2025 18:27:35 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id AC9duzKSIp1aBAC9euPr1R; Wed, 30 Apr 2025 18:27:34 +0000
X-Authority-Analysis: v=2.4 cv=Y7T+sAeN c=1 sm=1 tr=0 ts=68126b96
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=efVMuJ2jJG67FGuSm7J3ww==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7T7KSl7uo7wA:10
 a=6yfx0up5UoRXeW_57n8A:9 a=QEXdDO2ut3YA:10 a=Xt_RvD8W3m28Mn_h3AK8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Y7b0SrnsMBxBUF3wTDa4FZHX6WIDaAZjaSiOEx6wD28=; b=RToXduq7UX3SU3KHHCbFfN4jBP
	cpNo407367PXBy3uv03NbZRhkEkKNTGu+ufR6azOqU/H0524w0EhcSEXpnypolJ3+LI2eg/qqRsnc
	Y5WGzX/17iRMGg20QazhckTTHdFWn5QteEqWLD+2udsp4KDoHcjqkXQRQXjhyHD0LMJrnwlBUERcT
	trSwjekJ8QPjNsksmS+ujlUQp0yw3LphUT85QX8o2ZeGmD8ZVi7HPRF43vpgajGULk9ZjUm4EkqSU
	mDI9nDu3F/14lQN9DwlIlpXOJXa+wBAvmrxnpHnnAvD1cpf04xuTIPCJaz3BonEybuCg/037GCyDp
	OyO38Qow==;
Received: from [177.238.17.151] (port=62754 helo=[192.168.0.101])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1uAC9d-00000001Sg8-0kie;
	Wed, 30 Apr 2025 13:27:33 -0500
Message-ID: <a1edcb19-f463-4d15-be3d-2393191c45fd@embeddedor.com>
Date: Wed, 30 Apr 2025 12:27:26 -0600
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] bcachefs: Avoid -Wflex-array-member-not-at-end
 warning
To: Kent Overstreet <kent.overstreet@linux.dev>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aBF5udHEHwWvmWJw@kspp>
 <wxh5qw7hzvvyg4texozjbviicfe2xmbjxngwlc3a7xef6jm6kn@wi3f25t2fftd>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <wxh5qw7hzvvyg4texozjbviicfe2xmbjxngwlc3a7xef6jm6kn@wi3f25t2fftd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.17.151
X-Source-L: No
X-Exim-ID: 1uAC9d-00000001Sg8-0kie
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.101]) [177.238.17.151]:62754
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfB7JPxSa20w0Qj5gb++JoM5HilVNo93zmsJlJVZayr3ZuGemrjPMJYw4ZHzViJkMYTkyfvVL8JaUALAARog4YSvRWUl9i7HtPU6jORaXy0MlQMkbspq6
 HNIUob3Um+NQwEE2G8eRWpsKAciPGrITKBmSE225iVnKloVinR8QqtIrnjRMHkxBj7FPDfMMvl8uDGE3zww5SPvQTl6TbTeQczHXsSFOzUc0ZXJNzIODwHOo



On 29/04/25 19:40, Kent Overstreet wrote:
> On Tue, Apr 29, 2025 at 07:15:37PM -0600, Gustavo A. R. Silva wrote:
>> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
>> getting ready to enable it, globally.
>>
>> Use the `DEFINE_FLEX()` helper for on-stack definitions of a flexible
>> structure where the size of the flexible-array member is known at
>> compile-time, and refactor the rest of the code, accordingly.
>>
>> So, with these changes, fix the following warning:
>>
>> fs/bcachefs/disk_accounting.c:429:51: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> We also have bch_replicas_padded, does that also need a fix?

Yes - so, how about the following to address both issues:

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 7be71952425c..2dcccf1edbb9 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -287,7 +287,7 @@ static inline bool accounting_to_replicas(struct bch_replicas_entry_v1 *r, struc

  static int bch2_accounting_update_sb_one(struct bch_fs *c, struct bpos p)
  {
-       struct bch_replicas_padded r;
+       union bch_replicas_padded r;
         return accounting_to_replicas(&r.e, p)
                 ? bch2_mark_replicas(c, &r.e)
                 : 0;
@@ -361,7 +361,7 @@ static int __bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accoun
  int bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accounting a,
                                enum bch_accounting_mode mode)
  {
-       struct bch_replicas_padded r;
+       union bch_replicas_padded r;

         if (mode != BCH_ACCOUNTING_read &&
             accounting_to_replicas(&r.e, a.k->p) &&
@@ -425,10 +425,12 @@ int bch2_fs_replicas_usage_read(struct bch_fs *c, darray_char *usage)

         percpu_down_read(&c->mark_lock);
         darray_for_each(acc->k, i) {
-               struct {
+               union {
+                       u8 bytes[struct_size_t(struct bch_replicas_usage, r.devs,
+                                              BCH_BKEY_PTRS_MAX)];
                         struct bch_replicas_usage r;
-                       u8 pad[BCH_BKEY_PTRS_MAX];
                 } u;
+               u.r.r.nr_devs = BCH_BKEY_PTRS_MAX;

                 if (!accounting_to_replicas(&u.r.r, i->pos))
                         continue;
@@ -627,7 +629,7 @@ static int bch2_disk_accounting_validate_late(struct btree_trans *trans,

         switch (acc->type) {
         case BCH_DISK_ACCOUNTING_replicas: {
-               struct bch_replicas_padded r;
+               union bch_replicas_padded r;
                 __accounting_to_replicas(&r.e, acc);

                 for (unsigned i = 0; i < r.e.nr_devs; i++)
diff --git a/fs/bcachefs/ec_types.h b/fs/bcachefs/ec_types.h
index 06144bfd9c19..809446c78951 100644
--- a/fs/bcachefs/ec_types.h
+++ b/fs/bcachefs/ec_types.h
@@ -4,9 +4,10 @@

  #include "bcachefs_format.h"

-struct bch_replicas_padded {
+union bch_replicas_padded {
+       u8                              bytes[struct_size_t(struct bch_replicas_entry_v1,
+                                                           devs, BCH_BKEY_PTRS_MAX)];
         struct bch_replicas_entry_v1    e;
-       u8                              pad[BCH_BKEY_PTRS_MAX];
  };

  struct stripe {
@@ -28,7 +29,7 @@ struct gc_stripe {
         u16                     block_sectors[BCH_BKEY_PTRS_MAX];
         struct bch_extent_ptr   ptrs[BCH_BKEY_PTRS_MAX];

-       struct bch_replicas_padded r;
+       union bch_replicas_padded r;
  };

  #endif /* _BCACHEFS_EC_TYPES_H */
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 58e3983d860a..7c09a3c109ab 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1404,7 +1404,7 @@ int bch2_journal_read(struct bch_fs *c,
         }

         genradix_for_each(&c->journal_entries, radix_iter, _i) {
-               struct bch_replicas_padded replicas = {
+               union bch_replicas_padded replicas = {
                         .e.data_type = BCH_DATA_journal,
                         .e.nr_devs = 0,
                         .e.nr_required = 1,
@@ -1632,7 +1632,7 @@ static CLOSURE_CALLBACK(journal_write_done)
         closure_type(w, struct journal_buf, io);
         struct journal *j = container_of(w, struct journal, buf[w->idx]);
         struct bch_fs *c = container_of(j, struct bch_fs, journal);
-       struct bch_replicas_padded replicas;
+       union bch_replicas_padded replicas;
         u64 seq = le64_to_cpu(w->data->seq);
         int err = 0;

@@ -2055,7 +2055,7 @@ CLOSURE_CALLBACK(bch2_journal_write)
         closure_type(w, struct journal_buf, io);
         struct journal *j = container_of(w, struct journal, buf[w->idx]);
         struct bch_fs *c = container_of(j, struct bch_fs, journal);
-       struct bch_replicas_padded replicas;
+       union bch_replicas_padded replicas;
         unsigned nr_rw_members = dev_mask_nr(&c->rw_devs[BCH_DATA_journal]);
         int ret;

diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 66bfb95f1ea4..0acaf20f2181 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -953,7 +953,7 @@ int bch2_journal_flush_device_pins(struct journal *j, int dev_idx)
         seq = 0;
         spin_lock(&j->lock);
         while (!ret) {
-               struct bch_replicas_padded replicas;
+               union bch_replicas_padded replicas;

                 seq = max(seq, journal_last_seq(j));
                 if (seq >= j->pin.back)


Thanks
-Gustavo
