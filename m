Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A4324A049;
	Tue, 30 Sep 2025 20:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759265204; cv=none; b=Y9lb4qeHjG60wa6CEKoUZiCV8XK1fxmlTrpOeM1bHFA2KimGqpa9d0xs4YupOebWWec0S45XwuYGIkxv+wi0pRXQFhx6FG2MaHeifuY1ck0D2ENc53LwuknDcaxNzeM0N+5bsBFJe694h542LeBgUib1Ts8wdOsQD3Ck1FNcTpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759265204; c=relaxed/simple;
	bh=com4kiXikiCVndwAEIYfYH1tAB0tuOeE5JmbR65AU8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abTxCQtspMperopflJMiQfDanRpcIH1fOzTc32b/jUUIfu45ds+TsL2tW+J84wJynWhXrZhedz5uO/FbkNSg7sLWbcN58TXefy1f9ky5XNI9ifyg1s/GDFLWGWRQ3PaEAOeLHvj9yPThUZwKilEU5wpt5uNNIBP7LS+A2T9N4To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HEb4Oe+O; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HEb4Oe+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759265201; x=1790801201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=com4kiXikiCVndwAEIYfYH1tAB0tuOeE5JmbR65AU8w=;
  b=HEb4Oe+OUBjSdfq4cPlWqelMzydnJThBu+Gz8eKUC9/wcrx/YAWbFGY0
   yUbuUXxhaJ8shHjGGlU1XVPljmE0aYXZqbXbxPeVNUWb0iZYrHFUhzruK
   AQqfrRPGLq9SG9gPKroF/PceA+5blFRG0IUiitKS4alO704hQ+aVHBw+6
   mXzBQQaoxSOUhuNIpKa8w20mV8KVH3aukwi6V36b2q/pOY5uFrNm9xqc0
   QeFADwykC9YWyS7V4l3S1j2fbqqpFeV2qbRTLCK5t7nUY48uOga/nAPE0
   OeMOx4n0IHo29q+ZP0223DjhPB8JpEqWPCIvwbtRnBDGBBbanbNXjg2a3
   A==;
X-CSE-ConnectionGUID: KfkewKs7Tp6hii1SyBKeig==
X-CSE-MsgGUID: yJHheMzcR1aIHxoZ19pfVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61643432"
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="61643432"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 13:46:41 -0700
X-CSE-ConnectionGUID: Oorr7D4mQ8axOZMcRjWz3g==
X-CSE-MsgGUID: bwaVP5p3S/ml/SocPhrzvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,305,1751266800"; 
   d="scan'208";a="178202189"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 30 Sep 2025 13:46:38 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v3hF6-0002Tr-2D;
	Tue, 30 Sep 2025 20:46:36 +0000
Date: Wed, 1 Oct 2025 04:46:02 +0800
From: kernel test robot <lkp@intel.com>
To: Edward Adam Davis <eadavis@qq.com>,
	syzbot+ba71155d3eacc8f42477@syzkaller.appspotmail.com
Cc: oe-kbuild-all@lists.linux.dev, kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: Prevent written from exceeding sectors
Message-ID: <202510010446.t1B7jtcS-lkp@intel.com>
References: <tencent_68D8E912EEDECFF079226E202DFD6E70950A@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_68D8E912EEDECFF079226E202DFD6E70950A@qq.com>

Hi Edward,

kernel test robot noticed the following build warnings:

[auto build test WARNING on brauner-vfs/vfs.all]
[also build test WARNING on v6.17]
[cannot apply to linus/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Edward-Adam-Davis/bcachefs-Prevent-written-from-exceeding-sectors/20250930-132425
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/tencent_68D8E912EEDECFF079226E202DFD6E70950A%40qq.com
patch subject: [PATCH] bcachefs: Prevent written from exceeding sectors
config: sh-randconfig-001-20251001 (https://download.01.org/0day-ci/archive/20251001/202510010446.t1B7jtcS-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251001/202510010446.t1B7jtcS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510010446.t1B7jtcS-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/bcachefs/btree_io.c: In function 'bch2_btree_node_read_done':
>> fs/bcachefs/btree_io.c:1094:22: warning: format '%lu' expects argument of type 'long unsigned int', but argument 13 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
    1094 |                      "wrong written %u, btree sectors is %lu",
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1095 |                      ptr_written, btree_sectors(c));
         |                                   ~~~~~~~~~~~~~~~~
         |                                   |
         |                                   size_t {aka unsigned int}
   fs/bcachefs/btree_io.c:661:32: note: in definition of macro 'btree_err'
     661 |                                msg, ##__VA_ARGS__);                     \
         |                                ^~~
   fs/bcachefs/btree_io.c:1090:9: note: in expansion of macro 'btree_err_on'
    1090 |         btree_err_on(ptr_written >= btree_sectors(c),
         |         ^~~~~~~~~~~~
   fs/bcachefs/btree_io.c:1094:60: note: format string is defined here
    1094 |                      "wrong written %u, btree sectors is %lu",
         |                                                          ~~^
         |                                                            |
         |                                                            long unsigned int
         |                                                          %u


vim +1094 fs/bcachefs/btree_io.c

  1050	
  1051	int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
  1052				      struct btree *b,
  1053				      struct bch_io_failures *failed,
  1054				      struct printbuf *err_msg)
  1055	{
  1056		struct btree_node_entry *bne;
  1057		struct sort_iter *iter;
  1058		struct btree_node *sorted;
  1059		struct bkey_packed *k;
  1060		struct bset *i;
  1061		bool used_mempool, blacklisted;
  1062		bool updated_range = b->key.k.type == KEY_TYPE_btree_ptr_v2 &&
  1063			BTREE_PTR_RANGE_UPDATED(&bkey_i_to_btree_ptr_v2(&b->key)->v);
  1064		unsigned ptr_written = btree_ptr_sectors_written(bkey_i_to_s_c(&b->key));
  1065		u64 max_journal_seq = 0;
  1066		struct printbuf buf = PRINTBUF;
  1067		int ret = 0, write = READ;
  1068		u64 start_time = local_clock();
  1069	
  1070		b->version_ondisk = U16_MAX;
  1071		/* We might get called multiple times on read retry: */
  1072		b->written = 0;
  1073	
  1074		iter = mempool_alloc(&c->fill_iter, GFP_NOFS);
  1075		sort_iter_init(iter, b, (btree_blocks(c) + 1) * 2);
  1076	
  1077		if (bch2_meta_read_fault("btree"))
  1078			btree_err(-BCH_ERR_btree_node_read_err_must_retry,
  1079				  c, ca, b, NULL, NULL,
  1080				  btree_node_fault_injected,
  1081				  "dynamic fault");
  1082	
  1083		btree_err_on(le64_to_cpu(b->data->magic) != bset_magic(c),
  1084			     -BCH_ERR_btree_node_read_err_must_retry,
  1085			     c, ca, b, NULL, NULL,
  1086			     btree_node_bad_magic,
  1087			     "bad magic: want %llx, got %llx",
  1088			     bset_magic(c), le64_to_cpu(b->data->magic));
  1089	
  1090		btree_err_on(ptr_written >= btree_sectors(c),
  1091			     -BCH_ERR_btree_node_read_err_must_retry,
  1092			     c, ca, b, NULL, NULL,
  1093			     btree_node_bad_magic,
> 1094			     "wrong written %u, btree sectors is %lu",
  1095			     ptr_written, btree_sectors(c));
  1096	
  1097		if (b->key.k.type == KEY_TYPE_btree_ptr_v2) {
  1098			struct bch_btree_ptr_v2 *bp =
  1099				&bkey_i_to_btree_ptr_v2(&b->key)->v;
  1100	
  1101			bch2_bpos_to_text(&buf, b->data->min_key);
  1102			prt_str(&buf, "-");
  1103			bch2_bpos_to_text(&buf, b->data->max_key);
  1104	
  1105			btree_err_on(b->data->keys.seq != bp->seq,
  1106				     -BCH_ERR_btree_node_read_err_must_retry,
  1107				     c, ca, b, NULL, NULL,
  1108				     btree_node_bad_seq,
  1109				     "got wrong btree node: got\n%s",
  1110				     (printbuf_reset(&buf),
  1111				      bch2_btree_node_header_to_text(&buf, b->data),
  1112				      buf.buf));
  1113		} else {
  1114			btree_err_on(!b->data->keys.seq,
  1115				     -BCH_ERR_btree_node_read_err_must_retry,
  1116				     c, ca, b, NULL, NULL,
  1117				     btree_node_bad_seq,
  1118				     "bad btree header: seq 0\n%s",
  1119				     (printbuf_reset(&buf),
  1120				      bch2_btree_node_header_to_text(&buf, b->data),
  1121				      buf.buf));
  1122		}
  1123	
  1124		while (b->written < (ptr_written ?: btree_sectors(c))) {
  1125			unsigned sectors;
  1126			bool first = !b->written;
  1127	
  1128			if (first) {
  1129				bne = NULL;
  1130				i = &b->data->keys;
  1131			} else {
  1132				bne = write_block(b);
  1133				i = &bne->keys;
  1134	
  1135				if (i->seq != b->data->keys.seq)
  1136					break;
  1137			}
  1138	
  1139			struct nonce nonce = btree_nonce(i, b->written << 9);
  1140			bool good_csum_type = bch2_checksum_type_valid(c, BSET_CSUM_TYPE(i));
  1141	
  1142			btree_err_on(!good_csum_type,
  1143				     bch2_csum_type_is_encryption(BSET_CSUM_TYPE(i))
  1144				     ? -BCH_ERR_btree_node_read_err_must_retry
  1145				     : -BCH_ERR_btree_node_read_err_want_retry,
  1146				     c, ca, b, i, NULL,
  1147				     bset_unknown_csum,
  1148				     "unknown checksum type %llu", BSET_CSUM_TYPE(i));
  1149	
  1150			if (first) {
  1151				sectors = vstruct_sectors(b->data, c->block_bits);
  1152				if (btree_err_on(b->written + sectors > (ptr_written ?: btree_sectors(c)),
  1153						 -BCH_ERR_btree_node_read_err_fixable,
  1154						 c, ca, b, i, NULL,
  1155						 bset_past_end_of_btree_node,
  1156						 "bset past end of btree node (offset %u len %u but written %zu)",
  1157						 b->written, sectors, ptr_written ?: btree_sectors(c)))
  1158					i->u64s = 0;
  1159				if (good_csum_type) {
  1160					struct bch_csum csum = csum_vstruct(c, BSET_CSUM_TYPE(i), nonce, b->data);
  1161					bool csum_bad = bch2_crc_cmp(b->data->csum, csum);
  1162					if (csum_bad)
  1163						bch2_io_error(ca, BCH_MEMBER_ERROR_checksum);
  1164	
  1165					btree_err_on(csum_bad,
  1166						     -BCH_ERR_btree_node_read_err_want_retry,
  1167						     c, ca, b, i, NULL,
  1168						     bset_bad_csum,
  1169						     "%s",
  1170						     (printbuf_reset(&buf),
  1171						      bch2_csum_err_msg(&buf, BSET_CSUM_TYPE(i), b->data->csum, csum),
  1172						      buf.buf));
  1173	
  1174					ret = bset_encrypt(c, i, b->written << 9);
  1175					if (bch2_fs_fatal_err_on(ret, c,
  1176								 "decrypting btree node: %s", bch2_err_str(ret)))
  1177						goto fsck_err;
  1178				}
  1179	
  1180				btree_err_on(btree_node_type_is_extents(btree_node_type(b)) &&
  1181					     !BTREE_NODE_NEW_EXTENT_OVERWRITE(b->data),
  1182					     -BCH_ERR_btree_node_read_err_incompatible,
  1183					     c, NULL, b, NULL, NULL,
  1184					     btree_node_unsupported_version,
  1185					     "btree node does not have NEW_EXTENT_OVERWRITE set");
  1186			} else {
  1187				sectors = vstruct_sectors(bne, c->block_bits);
  1188				if (btree_err_on(b->written + sectors > (ptr_written ?: btree_sectors(c)),
  1189						 -BCH_ERR_btree_node_read_err_fixable,
  1190						 c, ca, b, i, NULL,
  1191						 bset_past_end_of_btree_node,
  1192						 "bset past end of btree node (offset %u len %u but written %zu)",
  1193						 b->written, sectors, ptr_written ?: btree_sectors(c)))
  1194					i->u64s = 0;
  1195				if (good_csum_type) {
  1196					struct bch_csum csum = csum_vstruct(c, BSET_CSUM_TYPE(i), nonce, bne);
  1197					bool csum_bad = bch2_crc_cmp(bne->csum, csum);
  1198					if (ca && csum_bad)
  1199						bch2_io_error(ca, BCH_MEMBER_ERROR_checksum);
  1200	
  1201					btree_err_on(csum_bad,
  1202						     -BCH_ERR_btree_node_read_err_want_retry,
  1203						     c, ca, b, i, NULL,
  1204						     bset_bad_csum,
  1205						     "%s",
  1206						     (printbuf_reset(&buf),
  1207						      bch2_csum_err_msg(&buf, BSET_CSUM_TYPE(i), bne->csum, csum),
  1208						      buf.buf));
  1209	
  1210					ret = bset_encrypt(c, i, b->written << 9);
  1211					if (bch2_fs_fatal_err_on(ret, c,
  1212							"decrypting btree node: %s", bch2_err_str(ret)))
  1213						goto fsck_err;
  1214				}
  1215			}
  1216	
  1217			b->version_ondisk = min(b->version_ondisk,
  1218						le16_to_cpu(i->version));
  1219	
  1220			ret = validate_bset(c, ca, b, i, b->written, READ, failed, err_msg);
  1221			if (ret)
  1222				goto fsck_err;
  1223	
  1224			if (!b->written)
  1225				btree_node_set_format(b, b->data->format);
  1226	
  1227			ret = validate_bset_keys(c, b, i, READ, failed, err_msg);
  1228			if (ret)
  1229				goto fsck_err;
  1230	
  1231			SET_BSET_BIG_ENDIAN(i, CPU_BIG_ENDIAN);
  1232	
  1233			blacklisted = bch2_journal_seq_is_blacklisted(c,
  1234						le64_to_cpu(i->journal_seq),
  1235						true);
  1236	
  1237			btree_err_on(blacklisted && first,
  1238				     -BCH_ERR_btree_node_read_err_fixable,
  1239				     c, ca, b, i, NULL,
  1240				     bset_blacklisted_journal_seq,
  1241				     "first btree node bset has blacklisted journal seq (%llu)",
  1242				     le64_to_cpu(i->journal_seq));
  1243	
  1244			btree_err_on(blacklisted && ptr_written,
  1245				     -BCH_ERR_btree_node_read_err_fixable,
  1246				     c, ca, b, i, NULL,
  1247				     first_bset_blacklisted_journal_seq,
  1248				     "found blacklisted bset (journal seq %llu) in btree node at offset %u-%u/%u",
  1249				     le64_to_cpu(i->journal_seq),
  1250				     b->written, b->written + sectors, ptr_written);
  1251	
  1252			b->written = min(b->written + sectors, btree_sectors(c));
  1253	
  1254			if (blacklisted && !first)
  1255				continue;
  1256	
  1257			sort_iter_add(iter,
  1258				      vstruct_idx(i, 0),
  1259				      vstruct_last(i));
  1260	
  1261			max_journal_seq = max(max_journal_seq, le64_to_cpu(i->journal_seq));
  1262		}
  1263	
  1264		if (ptr_written) {
  1265			btree_err_on(b->written < ptr_written,
  1266				     -BCH_ERR_btree_node_read_err_want_retry,
  1267				     c, ca, b, NULL, NULL,
  1268				     btree_node_data_missing,
  1269				     "btree node data missing: expected %u sectors, found %u",
  1270				     ptr_written, b->written);
  1271		} else {
  1272			for (bne = write_block(b);
  1273			     bset_byte_offset(b, bne) < btree_buf_bytes(b);
  1274			     bne = (void *) bne + block_bytes(c))
  1275				btree_err_on(bne->keys.seq == b->data->keys.seq &&
  1276					     !bch2_journal_seq_is_blacklisted(c,
  1277									      le64_to_cpu(bne->keys.journal_seq),
  1278									      true),
  1279					     -BCH_ERR_btree_node_read_err_want_retry,
  1280					     c, ca, b, NULL, NULL,
  1281					     btree_node_bset_after_end,
  1282					     "found bset signature after last bset");
  1283		}
  1284	
  1285		sorted = btree_bounce_alloc(c, btree_buf_bytes(b), &used_mempool);
  1286		sorted->keys.u64s = 0;
  1287	
  1288		b->nr = bch2_key_sort_fix_overlapping(c, &sorted->keys, iter);
  1289		memset((uint8_t *)(sorted + 1) + b->nr.live_u64s * sizeof(u64), 0,
  1290				btree_buf_bytes(b) -
  1291				sizeof(struct btree_node) -
  1292				b->nr.live_u64s * sizeof(u64));
  1293	
  1294		b->data->keys.u64s = sorted->keys.u64s;
  1295		*sorted = *b->data;
  1296		swap(sorted, b->data);
  1297		set_btree_bset(b, b->set, &b->data->keys);
  1298		b->nsets = 1;
  1299		b->data->keys.journal_seq = cpu_to_le64(max_journal_seq);
  1300	
  1301		BUG_ON(b->nr.live_u64s != le16_to_cpu(b->data->keys.u64s));
  1302	
  1303		btree_bounce_free(c, btree_buf_bytes(b), used_mempool, sorted);
  1304	
  1305		i = &b->data->keys;
  1306		for (k = i->start; k != vstruct_last(i);) {
  1307			struct bkey tmp;
  1308			struct bkey_s u = __bkey_disassemble(b, k, &tmp);
  1309	
  1310			ret = btree_node_bkey_val_validate(c, b, u.s_c, READ);
  1311			if (ret == -BCH_ERR_fsck_delete_bkey ||
  1312			    (static_branch_unlikely(&bch2_inject_invalid_keys) &&
  1313			     !bversion_cmp(u.k->bversion, MAX_VERSION))) {
  1314				btree_keys_account_key_drop(&b->nr, 0, k);
  1315	
  1316				i->u64s = cpu_to_le16(le16_to_cpu(i->u64s) - k->u64s);
  1317				memmove_u64s_down(k, bkey_p_next(k),
  1318						  (u64 *) vstruct_end(i) - (u64 *) k);
  1319				set_btree_bset_end(b, b->set);
  1320				set_btree_node_need_rewrite(b);
  1321				set_btree_node_need_rewrite_error(b);
  1322				continue;
  1323			}
  1324			if (ret)
  1325				goto fsck_err;
  1326	
  1327			if (u.k->type == KEY_TYPE_btree_ptr_v2) {
  1328				struct bkey_s_btree_ptr_v2 bp = bkey_s_to_btree_ptr_v2(u);
  1329	
  1330				bp.v->mem_ptr = 0;
  1331			}
  1332	
  1333			k = bkey_p_next(k);
  1334		}
  1335	
  1336		bch2_bset_build_aux_tree(b, b->set, false);
  1337	
  1338		set_needs_whiteout(btree_bset_first(b), true);
  1339	
  1340		btree_node_reset_sib_u64s(b);
  1341	
  1342		if (updated_range)
  1343			bch2_btree_node_drop_keys_outside_node(b);
  1344	
  1345		/*
  1346		 * XXX:
  1347		 *
  1348		 * We deadlock if too many btree updates require node rewrites while
  1349		 * we're still in journal replay.
  1350		 *
  1351		 * This is because btree node rewrites generate more updates for the
  1352		 * interior updates (alloc, backpointers), and if those updates touch
  1353		 * new nodes and generate more rewrites - well, you see the problem.
  1354		 *
  1355		 * The biggest cause is that we don't use the btree write buffer (for
  1356		 * the backpointer updates - this needs some real thought on locking in
  1357		 * order to fix.
  1358		 *
  1359		 * The problem with this workaround (not doing the rewrite for degraded
  1360		 * nodes in journal replay) is that those degraded nodes persist, and we
  1361		 * don't want that (this is a real bug when a btree node write completes
  1362		 * with fewer replicas than we wanted and leaves a degraded node due to
  1363		 * device _removal_, i.e. the device went away mid write).
  1364		 *
  1365		 * It's less of a bug here, but still a problem because we don't yet
  1366		 * have a way of tracking degraded data - we another index (all
  1367		 * extents/btree nodes, by replicas entry) in order to fix properly
  1368		 * (re-replicate degraded data at the earliest possible time).
  1369		 */
  1370		if (c->recovery.passes_complete & BIT_ULL(BCH_RECOVERY_PASS_journal_replay)) {
  1371			scoped_guard(rcu)
  1372				bkey_for_each_ptr(bch2_bkey_ptrs(bkey_i_to_s(&b->key)), ptr) {
  1373					struct bch_dev *ca2 = bch2_dev_rcu(c, ptr->dev);
  1374	
  1375					if (!ca2 || ca2->mi.state != BCH_MEMBER_STATE_rw) {
  1376						set_btree_node_need_rewrite(b);
  1377						set_btree_node_need_rewrite_degraded(b);
  1378					}
  1379				}
  1380		}
  1381	
  1382		if (!ptr_written) {
  1383			set_btree_node_need_rewrite(b);
  1384			set_btree_node_need_rewrite_ptr_written_zero(b);
  1385		}
  1386	fsck_err:
  1387		mempool_free(iter, &c->fill_iter);
  1388		printbuf_exit(&buf);
  1389		bch2_time_stats_update(&c->times[BCH_TIME_btree_node_read_done], start_time);
  1390		return ret;
  1391	}
  1392	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
